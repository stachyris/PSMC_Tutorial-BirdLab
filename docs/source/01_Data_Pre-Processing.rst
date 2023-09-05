Data pre-processing steps for PSMC
=====================================================

.. note::

 1) Make sure all of your packages are in your ``$PATH``
 2) Create a folder to work all of this - mine says ``PSMC_Tut``
 3) My working directory path is this - ``/Users/vinaykl/PSMC_Tut``
 4) And all of my packages are in ``/Users/vinaykl/softs``
 5) Remove the ``$`` sign from all of your code, if you copy from here. It denotes the beginning of prompt

A) Download Data for Jungle Owlet
----------------------------------------------

.. note::

  1. The direct FTP server are no longer active - for the ease of it, I have uploaded to GDrive and you 
     people can download from there
  2. These files are slightly larger - try and see if you can have a free space of about 150-200GB for the 
     entire excercise

.. code-block:: console

 READ1 : https://drive.google.com/file/d/1ENCTT4BJmZv2tM7Co6SfGOO4_RzOusxU/view?usp=sharing
 READ2 : https://drive.google.com/file/d/1BlcXiAotbHYDHmhhH8-HUcosccb48-53/view?usp=sharing

B) Check the QC of your RAW file
-----------------------------

.. code-block:: console
  
  $ mkdir fastqc_reports  #creating a folder called fastqc_reports to put the reports in one place
  $ ~/softs/FastQC/fastqc SRR12705961_1.fastq.gz SRR12705961_1.fastq.gz ./fastqc_reports # It will take about 15mins to 30mins depending on the system. 

.. note::
 
 1) Please go through the following document to understand what the each parameter represents and how you 
 can interpret your results : https://dnacore.missouri.edu/PDF/FastQC_Manual.pdf


C) Trim the RAW files using Trimmomatic
---------------------------------------

.. note::
 
 It took about 2h 20m on my Mac with 24GB RAM and 8 cores

.. code-block:: console

 $ java -jar /Users/vinaykl/softs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 -threads 16 -trimlog JO_trim.log -summary JO_summary.txt 
   SRR12705961_1.fastq.gz SRR12705961_2.fastq.gz JO_R1_paired.fq.gz JO_R1_unpaired.fq.gz JO_R2_paired.fq.gz JO_R2_unpaired.fq.gz 
   ILLUMINACLIP:/Users/vinaykl/softs/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36

D) Get the reference genome
---------------------------
While the trimming is going on, let us get the reference genome - Athene cunicularia - from Ensemble

I am creating a new folder named ``mapping`` under my ``PSMC_Tut`` directory. Having multiple direcotries helps you keep organised. 

.. code-block:: console

 $ mkdir mapping && cd mapping

Your directory should look like this now

.. code-block:: console

  ├──SRR12705961
  │   ├── JO_R1_paired.fq.gz
  │   ├── JO_R1_unpaired.fq.gz
  │   ├── JO_R2_paired.fq.gz
  │   ├── JO_R2_unpaired.fq.gz
  │   ├── JO_summary.txt
  │   ├── JO_trim.log
  │   ├── SRR12705961_1.fastq.gz
  │   ├── SRR12705961_2.fastq.gz
  │   └── fastqc_reports
  │       ├── SRR12705961_1_fastqc.html
  │       ├── SRR12705961_1_fastqc.zip
  │       ├── SRR12705961_2_fastqc.html
  │       └── SRR12705961_2_fastqc.zip
  └── mapping

 
Lets download the assembled genome in fasta file now

.. code-block:: console

 $ wget https://ftp.ensembl.org/pub/release- 110/fasta/athene_cunicularia/dna/Athene_cunicularia.athCun1.dna.toplevel.fa.gz
 $ gunzip Athene_cunicularia.athCun1.dna.toplevel.fa.gz


.. code-block:: concole
  
   |
   |
   |
   |
   └── mapping
         └── Athene_cunicularia.athCun1.dna.toplevel.fa


E) Map the trimmed data to a reference
---------------------------------------------------------------------------

.. note::
 
 At this point you can consider deleting some of the files from trimming ~ 
 ``SRR12705961_1.fastq.gz``  ``SRR12705961_2.fastq.gz``  ``.log``. This would account upto ~50GB. 

.. warning::

  * This is not advisable when you are working with your own data or on a project. 
 

Before we start mapping the data, we need to ``index`` the reference. 

.. code-block:: console

 $ ~/softs/bwa/bwa index ~/PSMC_Tut/mapping/Athene_cunicularia.athCun1.dna.toplevel.fa

Now we can start mapping

.. code-block:: bash

 $ bwa mem -M -t 16 -R "@RG\tID:JO_30x\tSM:JO_\tLB:IlluminaWGS\tPL:ILLUMINA" \ 
 /Users/vinaykl/PSMC_Tut/mapping/Athene_cunicularia.athCun1.dna.toplevel.fa \ 
 /Users/vinaykl/PSMC_Tut/SRR12705961/JO_R1_paired.fq.gz 
 /Users/vinaykl/PSMC_Tut/SRR12705961/JO_R2_paired.fq.gz \ 
 /Users/vinaykl/softs/samtools-1.18/bin/samtools view -bh - | \
 /Users/vinaykl/softs/samtools-1.18/bin/samtools sort -T tmp -o JO_map_athcun_ref.bam


.. note::

 This took about 6 hours 28 minutes on my M2 Mac with 8 cores and 24GB RAM. Potentially it *WILL* take 
 long time when you do it on your system. Could run for days. So plan accordingly. 


F) Filter the mapped data (Quality, Sort, PCR Duplicates removal)
-----------------------------------------------------------------

#filter based on quality filter

.. note::

 You could run all the following steps as one by combining them under the same script. But for the intial stage and understanding each step I would 
 recommend all of you to run them step by step. Plus, easy to troubleshoot if something doesn't work - for whatever reason. 


.. warning::

  When I ran steps by steps it took about three hours - an hour for each step. Again, remember I have run 
  these on a M2 Mac with 8 cores and 24GB RAM. It may vary for you based on your machine capability. 

.. code-block:: console

  $ ~/softs/samtools-1.18/bin/samtools view \
                   -bh \
                   -F 4 \
                   -q 30 \
                   -o JO_filtered.bam \
                   ./JO_map_athcun_ref.bam


#sort the filtered bam

.. code-block:: console

  $ ~/softs/samtools-1.18/bin/samtools sort \
                -o JO_filtered_sorted.bam \
                -T JO_filtered_temp \
                ./JO_filtered.bam


#remove PCR Duplicates

.. code-block:: console

 $ java -jar -Xmx8g -jar ~/softs/picard/build/libs/picard.jar MarkDuplicates \
     MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=900 \
     INPUT=JO_filtered_sorted.bam \
     OUTPUT=JO_filtered_sorted_rmdup.bam \
     ASSUME_SORTED=TRUE \
     REMOVE_DUPLICATES=true \
     METRICS_FILE=JO.rmdup.metrix.txt \
     TMP_DIR=./ \
     VALIDATION_STRINGENCY=SILENT


#Index the final bam

.. code-block:: console

 $ ~/softs/samtools-1.18/bin/samtools index JO_filtered_sorted_rmdup.bam


G) BAMQC

--------------------------------------------------------------------------

We need to do the QC, But will update that in few hours - Issue with JAVA 

.. warning:: 

 We will skip for the time-being. Idea behind running a bamqc is that Nadachowska-Brzyska K et., al 2016 papers shows that we need at least 17x of average coverage to infer demography history with confidence. 
Since, we now have two papers with this data we know that it's 24x average depth. QC softwares like ``Qualimap`` gives us this number.   


So for the next step, we need something called 'sequence report' which ideally we should've downloaded along with the reference genome - but I forgot, so lets download that now and copy it into the ``mapping`` folder under ``PSMC_tut`` directory. (I have uploaded that to same GDrive folder now)

.. note:: 

 Basically every refernce genome you download from a public repository like ``NCBI-SRA`` or ``ENA`` or ``Ensmble`` it will have a accompanying text file with chromosome and other sequence information. 

.. code-block:: console

 https://drive.google.com/file/d/1NGa5Gw6ROHSzRfqJUpfh54gUJTFGkG3F/view?usp=sharing

H) Identifying sex linked chromosome

---------------------------------------------------------------------------

Sex chromosomes have a huge influence on the overall demographic curve - so we will identify them now. This is where the 'Sequence report' come into help - which has scaffolds/chromosome information regarding sex chromosomes and autosomes. 


.. note::
 
 This code will not work on all the files. This is tailor made for this particular sequence report 
 downloaded. So, just do not blindly copy and paste when you are working on your data. It will produce 
 blank files. 

.. code-block:: console

 #Lets get the length of each scaffold of the reference file
 $ ~/soft/bioawk -c fastx '{print ">" $name ORS length($seq)}' ~/PSMC_Tut/mapping/Athene_cunicularia.athCun1.dna.toplevel.fa | paste - - > length_of_each_scaffold_of_ath_cun_ensembl.txt
 
 # Now lets isolate the Z Chromosome scaffolds in to a text file
 $ less ./GCA_003259725.1_sequence_report.txt| grep 'Chromosome' | grep 'chrZ' > chromosome_scaffolds_Z.txt

 # Now lets isolate the Autosomal Chromosome scaffolds in to a text file
  $ less ./GCA_003259725.1_sequence_report.txt| grep 'Chromosome' | grep -v 'chrZ' > chromosome_scaffolds_aut.txt 

 # For downstream analysis we need to bed files. Please learn more about bed formats
 
 $ cut -f1 chromosome_scaffolds_Z.txt | grep -f - length_of_each_scaffold_of_ath_cun_ensembl.txt | sed 's,>,,' | sed 's,\.1,\.1\t0,' > chromosome_scaffolds_Z.bed

 $ cut -f1 chromosome_scaffolds_aut.txt | grep -f - length_of_each_scaffold_of_ath_cun_ensembl.txt | sed 's,>,,' | sed 's,\.1,\.1\t0,' > chromosome_scaffolds_aut.bed

---------------------------------------------------------------------------------

Now your mapping directory should look like this :

.. code-block:: console

 ├── Athene_cunicularia.athCun1.dna.toplevel.fa
 ├── Athene_cunicularia.athCun1.dna.toplevel.fa.amb
 ├── Athene_cunicularia.athCun1.dna.toplevel.fa.ann
 ├── Athene_cunicularia.athCun1.dna.toplevel.fa.bwt
 ├── Athene_cunicularia.athCun1.dna.toplevel.fa.fai
 ├── Athene_cunicularia.athCun1.dna.toplevel.fa.pac
 ├── Athene_cunicularia.athCun1.dna.toplevel.fa.sa
 ├── GCA_003259725.1_sequence_report.txt
 ├── JO.rmdup.metrix.txt
 ├── JO_filtered.bam
 ├── JO_filtered_sorted.bam
 ├── JO_filtered_sorted_rmdup.bam
 ├── JO_filtered_sorted_rmdup.bam.bai
 ├── JO_map_athcun_ref.bam
 ├── chromosome_scaffolds_Z.bed
 ├── chromosome_scaffolds_Z.txt
 ├── chromosome_scaffolds_aut.bed
 ├── chromosome_scaffolds_aut.txt
 └── length_of_each_scaffold_of_ath_cun_ensembl.txt
 

G) Retain data mapping only to Autosomal chromosomes from the reference.

--------------------------------------------------------------------------

I like to keep things neat, so I am moving out of ``mapping`` directory and creating a new directory called ``PSMC`` under ``PSMC_Tut``. We will process further steps in ``PSMC`` folder. 

.. code-block::

 $ mkdir PSMC
 
 $ cd PSMC

 Now lets remove the sex chromosomes and retain only autosomes

 $ ~/softs/samtools-1.18/bin/samtools view -b -L ../mapping/chromosome_scaffolds_aut.bed ../mapping/JO_filtered_sorted_rmdup.bam > JO_filtered_sorted_rmdup_aut.bam

.. note::

 This took about 45 minutes. 


H) Creating consensus fq file 
------------------------------

.. code-block::

 /usr/local/bin/bin/bcftools mpileup -C50 -f ~/PSMC_Tut/mapping/Athene_cunicularia.athCun1.dna.toplevel.fa ./JO_filtered_sorted_rmdup_aut.bam | /usr/local/bin/bin/bcftools call -c - | /usr/local/bin/bin/vcfutils.pl vcf2fq -d 10 -D 100 | gzip > JO_diploid.fq.gz





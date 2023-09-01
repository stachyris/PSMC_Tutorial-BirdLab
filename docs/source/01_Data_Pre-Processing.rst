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

---------------------------------------------------------------------------

We need to do the QC, But will update that in few hours - Issue with JAVA

--------------------------------------------------------------------------

So for the next step, we need something called 'sequence report' which ideally we should've downloaded along with the reference genome - but I forgot, so lets download that now. 

.. code-block:: console

 curl -OJX GET "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_003259725.1/download?include_annotation_type=SEQUENCE_REPORT&filename=GCF_003259725.1.zip" -H "Accept: application/zip"



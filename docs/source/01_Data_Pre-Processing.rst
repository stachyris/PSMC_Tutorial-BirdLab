Data pre-processing steps for PSMC using Jungle Owlet
=====================================================

.. note::

 1) Make sure all of your packages are in your $PATH
 2) Create a folder to work all of this - mine says "PSMC_Tut"
 3) My working directory path is this - /Users/vinaykl/PSMC_Tut
 4) And all of my packages are in /Users/vinaykl/softs
 5) Remove the ``$`` sign from all of your code, if you copy from here. It denotes the beginning of prompt

A) Download Data for Jungle Owlet from NCBI Cloud 
----------------------------------------------

.. note::

 1) The direct FTP server are no longer active - for the ease of it, I have uploaded to GDrive and you 
 people can download from there.
 2) These files are slightly larger - try and see if you can have a space about 100GB for the entire 
 excercise. 

B) Check the QC of your RAW file
-----------------------------

.. code-block:: console
  
  $ mkdir fastqc_reports  #creating a folder called fastqc_reports to put the reports in one place
  $ ~/softs/FastQC/fastqc SRR12705961_1.fastq.gz SRR12705961_1.fastq.gz ./fastqc_reports # It will take about 15mins to 30mins depending on the system. 


C) Trim the RAW files using Trimmomatic
---------------------------------------
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


E) Map the trimmed data to a reference - in our case to Athene cucnicularia
---------------------------------------------------------------------------

.. code-block:: bash

 $ bwa mem -M -t 16 -R "@RG\tID:JO_30x\tSM:JO_\tLB:IlluminaWGS\tPL:ILLUMINA" \ 
 /Users/vinaykl/PSMC_Tut/mapping/Athene_cunicularia.athCun1.dna.toplevel.fa \ 
 /Users/vinaykl/PSMC_Tut/SRR12705961/JO_R1_paired.fq.gz 
 /Users/vinaykl/PSMC_Tut/SRR12705961/JO_R2_paired.fq.gz \ 
 /Users/vinaykl/softs/samtools-1.18/bin/samtools view -bh - | \
 /Users/vinaykl/softs/samtools-1.18/bin/samtools sort -T tmp -o JO_map_athcun_ref.bam

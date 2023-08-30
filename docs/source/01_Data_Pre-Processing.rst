Data pre-processing steps for PSMC using Jungle Owlet
=====================================================

.. note::
1) Make sure all of your packages are in your $PATH
2) Create a folder to work all of this - mine says "PSMC_Tut"
3) My working directory path is this - /Users/vinaykl/PSMC_Tut
4) And all of my packages are in /Users/vinaykl/softs

A) Download Data for Jungle Owlet from NCBI Cloud 
----------------------------------------------

.. note::

1) The direct FTP server are no longer active - for the ease of it, I have uploaded to GDrive and you people can download from there. \ 
2) These files are slightly larger - try and see if you can have a space about 100GB. \

B) Check the QC of your RAW file
-----------------------------

.. code-block:: console
  
  $ mkdir fastqc_reports  #creating a folder called fastqc_reports to put the reports in one place
  $ ~/softs/FastQC/fastqc SRR12705961_1.fastq.gz SRR12705961_1.fastq.gz ./fastqc_reports


C) Trim the RAW files using Trimmomatic
---------------------------------------

.. code-block:: console

 java -jar /Users/vinaykl/softs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 -threads 16 -trimlog 
 JO_trim.log -summary JO_summary.txt  SRR12705961_1.fastq.gz SRR12705961_2.fastq.gz JO_R1_paired.fq.gz 
 JO_R1_unpaired.fq.gz JO_R2_paired.fq.gz JO_R2_unpaired.fq.gz 
 ILLUMINACLIP:/Users/vinaykl/softs/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 
 TRAILING:3 MINLEN:36


D) Map the trimmed data to a reference - in our case to Athene cucnicularia
---------------------------------------------------------------------------

.. code-block:: bash

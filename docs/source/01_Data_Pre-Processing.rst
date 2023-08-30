Data pre-processing steps for PSMC using Jungle Owlet
=====================================================

Download Data for Jungle Owlet from NCBI Cloud 
----------------------------------------------

.. note::
1) The direct FTP server are no longer active - for the ease of it, I have uploaded to GDrive and you people can download from there. \ 
2) Make sure all of the softwares are in your $PATH. \
3) These files are slightly larger - try and see if you can have a space about 100GB. \

A) Check the QC of your RAW file
-----------------------------

.. code-block:: bash

$ ~/softs/FastQC/fastqc SRR12705961_1.fastq.gz SRR12705961_1.fastq.gz ./fastqc_reports


B) Trim the RAW files using Trimmomatic
---------------------------------------

.. code-block:: bash

$ java -jar /Users/vinaykl/softs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 -trimlog JO_trim.log -summary JO_summary.txt  SRR12705961_1.fastq.gz SRR12705961_2.fastq.gz JO_R1_paired.fq.gz JO_R1_unpaired.fq.gz JO_R2_paired.fq.gz JO_R2_unpaired.fq.gz ILLUMINACLIP:Users/vinaykl/softs/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36


C) Map the trimmed data to a reference - in our case to Athene cucnicularia
---------------------------------------------------------------------------

.. code-block:: bash

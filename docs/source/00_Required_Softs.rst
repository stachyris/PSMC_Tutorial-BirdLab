Installation of required softwares
==================================

A) FastQC
-----------

Find the appropriate version comaptible for your operating system from here

.. code-block:: console

 $ wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip
 $ unzip fastqc_v0.12.1.zip


B) Trimmomatic
---------------

.. code-block:: console

 $ wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-0.39.zip
 $ unzip Trimmomatic-0.39.zip


C) Burrows-Wheeler Aligner
--------------------------

.. code-block:: console

 $ git clone https://github.com/lh3/bwa.git
 $ cd bwa; make


D) Samtools and htslib suit
----------------------------
You don't hae to get the htslib separately. 

.. code-block:: console

 $ wget https://github.com/samtools/samtools/releases/download/1.18/samtools-1.18.tar.bz2
 $ tar -xvzf samtools-1.18.tar.bz2 && cd samtools-1.18
 $ ./configure --prefix=/your/soft/path/name/
 $ make
 $ make install
 $ export PATH="/your/soft/path/name/samtools-1.18/bin:$PATH"

E) Picard Tools
---------------

.. code-block:: console

  $ git clone https://github.com/broadinstitute/picard.git
  $ cd picard
  $ ./gradlew shadowJar










Installation of required softwares
==================================

1) FastQC
-----------

Find the appropriate version comaptible for your operating system from here

.. code-block:: console

 $ wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip
 $ unzip fastqc_v0.12.1.zip


2) Trimmomatic
---------------

.. code-block:: console

 $ wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-0.39.zip
 $ unzip Trimmomatic-0.39.zip


3) Burrows-Wheeler Aligner
--------------------------

.. code-block:: console

 $ git clone https://github.com/lh3/bwa.git
 $ cd bwa; make


4) Samtools and htslib suit
----------------------------
You don't hae to get the htslib separately. 

.. code-block:: console

 $ wget https://github.com/samtools/samtools/releases/download/1.18/samtools-1.18.tar.bz2
 $ tar -xvzf samtools-1.18.tar.bz2 && cd samtools-1.18
 $ ./configure --prefix=/your/soft/path/name/
 $ make
 $ make install
 $ export PATH="/your/soft/path/name/samtools-1.18/bin:$PATH"

5) Picard Tools
---------------

.. code-block:: console

  $ git clone https://github.com/broadinstitute/picard.git
  $ cd picard
  $ ./gradlew shadowJar

6) Bioawk
----------

.. code-block:: console

 $ sudo git clone https://github.com/lh3/bioawk.git
 $ cd bioawk/
 $ sudo make
 $ ./bioawk

7) BCFTools
--------------

.. code-block:: console

 $ wget https://github.com/samtools/bcftools/releases/download/1.10.2/bcftools-1.10.2.tar.bz2
 $ tar -xjvf bcftools-1.10.2.tar.bz2
 $ cd bcftools-1.10.2
 $ make
 $ sudo make prefix=/usr/local/bin install
 $ sudo ln -s /usr/local/bin/bin/bcftools /usr/bin/bcftools # you don't technically need to do this. And if you aren't a root user you may get a ``permission denied`` message - don't worry about it. 


8) PSMC
--------

.. code-block:: console

 $ git clone https://github.com/lh3/psmc.git
 $ cd psmc
 $ make
 $ cd utils
 $ make

9) R and R-Studio
-----------------

Download ``R`` first - For Mac : https://cran.r-project.org/bin/macosx/
                   For Windows : https://cran.r-project.org/bin/windows/base/
 
Now Download ``R-Studio``. R-Studio is an IDE which helps you access R interactively. Alternatively you can use any other IDE like VS Code. 
Download the ``R-Studio`` - https://posit.co/download/rstudio-desktop/








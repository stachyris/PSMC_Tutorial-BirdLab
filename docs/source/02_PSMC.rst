Alright, Let's run the actual things - PSMC
-----------------------------------------------

.. note::

 Read more about the practicality and implemntation on the GitHub page of the project. https://github.com/lh3/psmc


A) Initial runs

.. code-block:: console

 # Let us first convert the diploid genome to PSMC suitable format ``psmcfa``
 $ ~/softs/psmc/utils/fq2psmcfa -q20 ./JO_diploid.fq.gz > JO_diploid.psmcfa


.. Attention::

 You need to understand each parameter we will be using below like ``-N25`` ``-t9`` ``-r5`` and ``-p`` before we proceed further. Parameters you see 
 here are optimised after several trial and errors, So you will get the results within a shot - but when you work on your own project it can take upto 
 *30-50* trials or even more (Skyisland Demography project took 78 trials) to optimise - depending on the quality of genome, species ecology etc. 

.. code-block:: console

 # Running PSMC to get initial idea about how the parameters is panning out. 
 $ ~softs/psmc/psmc -N25 -t9 -r5 -p "26*2+4+7+1" -o JO_diploid.psmc JO_diploid.psmcfa


.. code-block:: console

 # Lets get something called PSMC History
 $ ~/softs/psmc/utils/psmc2history.pl JO_diploid.psmc | ~softs/psmc/utils/history2ms.pl > ms-cmd-1.sh


B) Bootstrapping PSMC

.. code-block:: console

 ~/softs/psmc/utils/splitfa ../JO_diploid.psmcfa > JO_diploid_split.psmcfa

 ~/softs/psmc/psmc -N25 -t9 -r5 -p "26*2+4+7+1" -o JO_diploid.psmc ../JO_diploid.psmcfa


Next step - where its actually bootstrapping- code is slightly different for Mac and Linux, So accordingly choose the code chunk

.. code-block:: console
 
 # For Mac
 seq 100 | xargs -I{} -n 1 -P 8 echo ~/softs/psmc/psmc -N25 -t9 -r5 -b -p "26*2+4+7+1" -o JO_diploid_round-{}.psmc JO_diploid_split.psmcfa | sh


.. code-block:: console 

 # For Linux/WSL

 seq 100 | xargs -i -n 1 -P 8 echo ~/softs/psmc/psmc -N25 -t9 -r5 -b -p "26*2+4+7+1" -o JO_diploid_round-{}.psmc JO_diploid_split.psmcfa | sh


.. code-block:: console 
 
 cat ../JO_diploid.psmc JO_diploid_round-*.psmc > JO_diploid_combined.psmc
 

                                                                        

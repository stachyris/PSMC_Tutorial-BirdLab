Alright, Let's run the actual things - PSMC
-----------------------------------------------

.. note::

 Read more about the practicality and implemntation on the GitHub page of the project. https://github.com/lh3/psmc


.. code-block:: console

 # Let us first convert the diploid genome to PSMC suitable format ``psmcfa``
 $ ~/softs/psmc/utils/fq2psmcfa -q20 ./JO_diploid.fq.gz > JO_diploid.psmcfa

.. code-block:: console

 # Running PSMC to get initial idea about how the parameters is panning out. Will talk more about how to optimise the parameters. 
 $ ~softs/psmc/psmc -N25 -t9 -r5 -p "26*2+4+7+1" -o JO_diploid.psmc JO_diploid.psmcfa


.. code-block:: console

 # Lets get something called PSMC History
 $ ~/softs/psmc/utils/psmc2history.pl JO_diploid.psmc | ~softs/psmc/utils/history2ms.pl > ms-cmd-1.sh

                                                                        

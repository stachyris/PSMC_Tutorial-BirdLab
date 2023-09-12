Alright, Let's run the actual things - PSMC
==============================================

.. note::

 Read more about the practicality and implemntation on the GitHub page of the project. https://github.com/lh3/psmc


A) Initial runs
----------------

.. code-block:: console

 # Let us first convert the diploid genome to PSMC suitable format ``psmcfa``
 $ ~/softs/psmc/utils/fq2psmcfa -q20 ./JO_diploid.fq.gz > JO_diploid.psmcfa


.. Attention::

 You need to understand each parameter we will be using below like ``-N25`` ``-t9`` ``-r5`` and ``-p`` before we proceed further. Parameters you see 
 here are optimised after several trial and errors, So you will get the results within a shot - but when you work on your own project it can take upto 
 *30-50* trials or even more (Skyisland Demography project took 78 trials) to optimise - depending on the quality of genome, species ecology etc. 

 * ``N`` corresponds to number of iterations
 * ``t`` corresponds to time - basically how long we want to go back in time
 * ``p`` corresponds to the free atomic interval. 

  " The `-p' and `-t' options are manually chosen such that after 20 rounds of iterations, at least ~10 
  recombinations are inferred to occur in the intervals each parameter spans. Impropriate settings may 
  lead to overfitting " This is from the README of the PSMC package. 

.. code-block:: console

 # Running PSMC to get initial idea about how the parameters is panning out. 
 $ ~softs/psmc/psmc -N25 -t9 -r5 -p "26*2+4+7+1" -o JO_diploid.psmc JO_diploid.psmcfa

.. note:: 

 So when you finish running the above, you need to inspect the parameters (you can just use ``less`` to 
 open). In our case the number of recombinations is higher than recommended 10 as this is already 
 optimised parameter. 

 If it is not above ``10``, go back to your PSMC script and change ``-t`` and ``-p``. One way to tackle 
 this is to keep the ``-p`` constant and change ``-t`` and check - but this may result in the ``PSMC`` 
 result not going back in time you desired. But eventually you will have to play with ``-p``. 
 
 ....I will try and see if I can put up my previous combinations and trials somewhere so that you people 
 can get idea....

.. code-block:: console

 # Lets get something called PSMC History
 $ ~/softs/psmc/utils/psmc2history.pl JO_diploid.psmc | ~softs/psmc/utils/history2ms.pl > ms-cmd-1.sh


B) Bootstrapping PSMC
----------------------

Now to keep things clean let's make a new directory named ``boots`` and run all the bootstrapping files and outputs. 

.. code-block:: console

 $ mkdir boots
 $ cd boots

Your overall directory structure should look like this now

.. code-block:: console

 ├── PSMC
 │   └── boots
 ├── SRR12705961
 │   └── fastqc_reports
 └── mapping
    

.. code-block:: console

 $ ~/softs/psmc/utils/splitfa ../JO_diploid.psmcfa > JO_diploid_split.psmcfa

 $ ~/softs/psmc/psmc -N25 -t9 -r5 -p "26*2+4+7+1" -o JO_diploid.psmc ../JO_diploid.psmcfa


.. attention::

 Next step - where its actually bootstrapping- code is slightly different for Mac and Linux, So 
 accordingly choose the code chunk. 

.. note::

 Sadly, I haven't figured out how to run these parallelly, so it will run on single core. It took about 
 ~25 minutes for each iterations, so it may run upto 40h-42h. 


.. code-block:: console
 
 # For Mac
 $ seq 100 | xargs -I{} -n 1 -P 8 echo ~/softs/psmc/psmc -N25 -t9 -r5 -b -p "26*2+4+7+1" -o JO_diploid_round-{}.psmc JO_diploid_split.psmcfa | sh


.. code-block:: console 

 # For Linux/WSL

 $ seq 100 | xargs -i -n 1 -P 8 echo ~/softs/psmc/psmc -N25 -t9 -r5 -b -p "26*2+4+7+1" -o JO_diploid_round-{}.psmc JO_diploid_split.psmcfa | sh


.. code-block:: console 
 
 $ cat ../JO_diploid.psmc JO_diploid_round-*.psmc > JO_diploid_combined.psmc



C) Final text output
--------------------

Now we need to transform these results in a way which is easy to interpret. So, for that we need ``generation time``, ``mutation rate``. First we will generate the ``R`` compatible outputs without scaling ``Θ`` the data. 

.. code-block:: console

 $ ~/softs/psmc/utils/psmc_plot.pl -S -R -u 4e-09 -g 2 JO_diploid_no_scaling ./JO_diploid.psmc


Let's now scale this to ``years``. 

.. note::

 During the bootstrapping step we ``combined`` the outputs. This ``combined`` file contains data for 100 iterations of bootstapping and original PSMC 
 results. So we can scale just that one file. 

.. code-block:: console

 $ mkdir final_text_output; cd final_text_output

 $ ~/softs/psmc/utils/psmc_plot.pl -R -u 4e-09 -g 2 -pY50000 JO_diploid ../JO_diploid_combined.psmc

 
.. attention::

 Non-scaled plot helps us to gauge the results - ideally the trajectory of your PSMC curve should not 
 change/alter from non-sclaed to scaled. 
                                                                        

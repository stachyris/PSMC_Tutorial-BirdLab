library("ggpubr") #this is the R library we gonna be using

setwd("/Users/vinaykl/PSMC_Tut/PSMC/visualization") #this is the directory of the files where all the PSMC outputs are saved. 

op <- par(family = "serif") #select a font for your plots

#lets make a blank plot
plot(1,1,
     ylim=c(0,80),xlim=c(2,700),
     log="x",type="n",
     main="",ylab="Effective Population Size (10^4)",xlab="Years ago 10^3")

#lets add lines at different time point of our interest. 
abline(v=c(6,22,120), col="black")
text(119.85,75.18514,"LIG",cex=1.0) 
text(21.63997,75.18514,"LGM",cex=1.0)
text(5.928641,75.18514,"MDH",cex=1.0)


# extract bootstrap values for each species separately. 
for(i in 0:100) {
  path<-paste0("JO/JO1_aut-8c-combined.",i,".txt")
  boot.iter<-read.table(path)
  ya<-boot.iter[-1,1]
  ya.pl=ya[which(ya>4999)]
  ne<-boot.iter[-1,2]
  ne.pl=ne[which(ya>4999)]
  lines((ya/1000),ne,xlog=T,type="l",col=alpha("cornflowerblue",0.1),lwd=0.8,ylim=c(0,50))
}


for(i in 0:100) {
  path<-paste0("SO/SOT_aut-8c-combined.",i,".txt")
  boot.iter<-read.table(path)
  ya<-boot.iter[-1,1]
  ya.pl=ya[which(ya>4999)]
  ne<-boot.iter[-1,2]
  ne.pl2=ne[which(ya>4999)]
  lines((ya/1000),ne,xlog=T,type="l",col=alpha("black",0.1), lwd=0.8,ylim=c(0,50))
}



for(i in 0:100) {
  path<-paste0("FO/FO_100x_combined.",i,".txt")
  boot.iter<-read.table(path)
  ya<-boot.iter[-1,1]
  ya.pl=ya[which(ya>4999)]
  ne<-boot.iter[-1,2]
  ne.pl=ne[which(ya>4999)]
  lines((ya/1000),ne,xlog=T,type="l",col=alpha("coral3",0.1), lwd=0.8,ylim=c(0,50))
}


#adding the legend to the plot - feel free to customize. 
legend(160, 77, legend=c("Forest Owlet", "Jungle Owlet", "Spotted Owlet"),
       col=c("coral3", "cornflowerblue", "black"), lty=1, cex=1.0, box.lty=5)

# lets extract values of the main PSMC results for each species separately. 
jo = read.table("JO/JO1_aut-8c-combined.0.txt")
jo.ya=jo[-1,1]
jo.ne=jo[-1,2]

fo = read.table("FO/FO_100x_combined.0.txt")
fo.ya=fo[-1,1]
fo.ne=fo[-1,2]

so = read.table("SO/SOT_aut-8c-combined.0.txt")
so.ya=so[-1,1]
so.ne=so[-1,2]

#lets plot those extracted values. 
lines(x=(so.ya/1000),y=so.ne,type="l",col="black",lwd=2.5)
lines(x=(jo.ya/1000),y=jo.ne,type="l",col="cornflowerblue",lwd=2.5)
lines(x=(fo.ya/1000),y=fo.ne,type="l",col="coral3",lwd=2.5)

      

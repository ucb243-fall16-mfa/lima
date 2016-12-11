library(ggplot2)
library(gridExtra)
#1.plot eigen

#Color table
defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", 
                   "#0099c6", "#dd4477","#ee9911","#341090","#13dd32",
                   "#115577","#ab7533","#6331af","#ee7129","#7743dd")

plot_eigen <- function(x){
  
  eigen<-data.frame("eigen"=x@eigenvalues)
  eigen$id<-sapply(c(1:length(x@eigenvalues)),function(x){paste0("Dim",x)})
  
  
  p2<-ggplot2::ggplot(data=eigen,ggplot2::aes(x=factor(id,levels=id),y=eigen,fill=factor(id,levels=id)))+
    ggplot2::geom_bar(stat="identity",width=0.5)+
    ggthemes::scale_fill_calc()+
    ggplot2::theme(plot.title = ggplot2::element_text(size=22, face="bold",vjust=1,color="grey40"),
                   axis.title.x = ggplot2::element_text(size=18, face="bold",vjust=-0.5,color="grey40"),
                   axis.title.y = ggplot2::element_text(size=18, face="bold",vjust=0.5,color="grey40"),
                   legend.title=ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   panel.grid.minor = ggplot2::element_line(colour = "grey90",size=0.2),
                   panel.grid.major = ggplot2::element_line(colour = "grey90",size=0.2),
                   axis.text.x = ggplot2::element_text(color="grey40",size=8),
                   axis.text.y = ggplot2::element_text(color="grey40",size=8),
                   legend.text=ggplot2::element_text(size=8))+
    ggplot2::ggtitle(paste0("Eigenvalues"))+ggplot2::labs(x="",y="")+
    ggplot2::guides(fill = ggplot2::guide_legend(keywidth = 2, keyheight = 2))
  p2
  
}

#2.common factor scores
plot_common <- function(x,dim){
  
  names<-sapply(dim,function(x){paste0("Dim",x)})
  compromise<-data.frame(x@common_factor_score[,dim])
  compromise$id<-rownames(compromise)
  # plot compromise factor score of the two dimension ##############
  p1<-ggplot2::ggplot()+
    ggplot2::geom_point(data=compromise,ggplot2::aes(x=compromise[,1],y=compromise[,2],color=id),size=8)+
    ggplot2::theme(plot.title = ggplot2::element_text(size=18, face="bold",vjust=1,color="grey40"),
                   axis.title.x = ggplot2::element_text(size=12, face="bold",vjust=-0.5,color="grey40"),
                   axis.title.y = ggplot2::element_text(size=12, face="bold",vjust=0.5,color="grey40"),
                   legend.title=ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   panel.grid.minor = ggplot2::element_line(colour = "grey90",size=0.2),
                   panel.grid.major = ggplot2::element_line(colour = "grey90",size=0.2),
                   legend.text=ggplot2::element_text(size=8))+
    ggthemes::scale_color_calc()+
    ggplot2::guides(color = ggplot2::guide_legend(keywidth = 0.9, keyheight = 0.9))+
    # plot x and y axis
    ggplot2::annotate("segment", x=-Inf,xend=Inf,y=0,yend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.3,"cm")),size=0.5,color="grey60") +
    ggplot2::annotate("segment", y=-Inf,yend=Inf,x=0,xend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.3,"cm")),size=0.5,color="grey60")+
    # center (0,0)
    ggplot2::xlim(-max(abs(compromise[,1]))*1.1, max(abs(compromise[,1]))*1.1)+
    ggplot2::ylim(-max(abs(compromise[,2]))*1.1, max(abs(compromise[,2]))*1.1)+
    ggplot2::ggtitle(paste0("Compromise Factor Score"))+ggplot2::labs(x=names[1],y=names[2])
  p1
}

#3.partial factor scores
# plot method and functions for plot mfa
partial_plot<-function(group_num,data,data2,names){
  p = ggplot2::ggplot()+
    ## ?refer color table
    ggplot2::geom_point(data=data,ggplot2::aes(x=data[,1],y=data[,2],color = id),size=5)+
    ggplot2::geom_point(data=data2,ggplot2::aes(x=data2[,1],y=data2[,2]),color="grey10",shape=17,size=3.5)+
    ggplot2::geom_text(data=data2,ggplot2::aes(x=data2[,1],y=data2[,2],label=rownames(data2)),size=4,color="black",hjust=-0.15, vjust=-0.05)+
    ggplot2::scale_shape_manual(values=group_num+1)+
    ggplot2::theme(plot.title = ggplot2::element_text(size=18, face="bold",vjust=0.05,color="grey40"),
                   axis.title.x = ggplot2::element_text(size=18, face="bold",vjust=-0.05,color="grey40"),
                   axis.title.y = ggplot2::element_text(size=18, face="bold",vjust=0.05,color="grey40"),
                   legend.position="right",
                   axis.text.x = ggplot2::element_text(color="grey40",size=12),
                   axis.text.y = ggplot2::element_text(color="grey40",size=12),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_line(colour = "grey90",size=0.3),
                   panel.background = ggplot2::element_blank())+
    # plot x and y axis
    ggthemes::scale_color_calc()+
    ggplot2::annotate("segment", x=-Inf,xend=Inf,y=0,yend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.2,"cm")),size=0.3,color="grey50") +
    ggplot2::annotate("segment", y=-Inf,yend=Inf,x=0,xend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.2,"cm")),size=0.3,color="grey50")+
    # center (0,0)
    ggplot2::xlim(-max(abs(c(data[,1],data2[,1])))*1.2, max(abs(c(data[,1],data2[,1])))*1.2)+
    ggplot2::ylim(-max(abs(c(data[,2],data2[,2])))*1.2, max(abs(c(data[,2],data2[,2])))*1.2)+
    ggplot2::ggtitle(paste0("Partial Factor Score: Group ",group_num))+ggplot2::labs(x=names[1],y=names[2])
  p
}


plot_partial <- function(x,dim){
  names<-sapply(dim,function(x){paste0("Dim",x)})
  partial<-lapply(x@partial_factor_score,function(x){x[,dim]})
  loadings<- -data.frame(x@loadings[,dim])
  sets = x@sets
  plist <- list()
  
  for (i in 1:length(sets)){
    mydata<-data.frame(partial[[i]])
    mydata[,2]<- -mydata[,2]
    mydata$id<-rownames(mydata)
    mydata2<-loadings[sets[[i]],]
    mydata2[,1]<- -mydata2[,1]
    myplot<-partial_plot(i,mydata,mydata2,names)
    plist[[i]]<-myplot
  }
  p3<-do.call(get("grid.arrange", asNamespace("gridExtra")),c(plist,ncol=5,top=""))
  p3
}

plot_loadings <- function(x,dim){
  names<-sapply(dim,function(x){paste0("Dim",x)})
  loadings<- -data.frame(x@loadings[,dim])
  loadings$id<-rownames(loadings)
  p4<-ggplot2::ggplot()+
    ggplot2::geom_point(data=loadings,ggplot2::aes(x=loadings[,1],y=loadings[,2],color=factor(id,levels = id)),size=5)+
    ggplot2::theme(plot.title = ggplot2::element_text(size=22, face="bold",vjust=1,color="grey40"),
                   axis.title.x = ggplot2::element_text(size=18, face="bold",vjust=-0.5,color="grey40"),
                   axis.title.y = ggplot2::element_text(size=18, face="bold",vjust=0.5,color="grey40"),
                   legend.title=ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank())+
    #               panel.grid.minor = ggplot2::element_line(colour = "grey90",size=0.2),
    #               panel.grid.major = ggplot2::element_line(colour = "grey90",size=0.2),
    #               legend.text=ggplot2::element_text(size=8))+
    #ggthemes::scale_color_calc()+
    ggplot2::guides(color = ggplot2::guide_legend(keywidth = 0.9, keyheight = 0.9))+
    # plot x and y axis
    ggplot2::annotate("segment", x=-Inf,xend=Inf,y=0,yend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.3,"cm")),size=0.5,color="grey60") +
    ggplot2::annotate("segment", y=-Inf,yend=Inf,x=0,xend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.3,"cm")),size=0.5,color="grey60")+
    # center (0,0)
    ggplot2::xlim(-max(abs(loadings[,1]))*1.1, max(abs(loadings[,1]))*1.1)+
    ggplot2::ylim(-max(abs(loadings[,2]))*1.1, max(abs(loadings[,2]))*1.1)+
    ggplot2::ggtitle(paste0("The Loadings"))+ggplot2::labs(x=names[1],y=names[2])
  p4
}
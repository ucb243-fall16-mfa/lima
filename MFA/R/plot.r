# set plot() to plot table given two dimensions
# plot method and functions for plot mfa
partial_plot<-function(group_num,data,data2,names){
  ggplot2::ggplot()+
    ggplot2::geom_point(data=data,ggplot2::aes(x=data[,1],y=data[,2],color=id),size=2)+
    ggplot2::geom_point(data=data2,ggplot2::aes(x=data2[,1],y=data2[,2]),color="grey10",shape=17,size=1.5)+
    ggplot2::geom_text(data=data2,ggplot2::aes(x=data2[,1],y=data2[,2],label=id),size=2,color="black",hjust=-0.15, vjust=-0.05)+
    ggplot2::scale_shape_manual(values=group_num+1)+
    ggplot2::theme(plot.title = ggplot2::element_text(size=8, face="bold",vjust=0.05,color="grey40"),
                   axis.title.x = ggplot2::element_text(size=8, face="bold",vjust=-0.05,color="grey40"),
                   axis.title.y = ggplot2::element_text(size=8, face="bold",vjust=0.05,color="grey40"),
                   legend.position="none",
                   axis.text.x = ggplot2::element_text(color="grey40",size=8),
                   axis.text.y = ggplot2::element_text(color="grey40",size=8),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_line(colour = "grey90",size=0.1),
                   panel.background = ggplot2::element_blank())+
    # plot x and y axis
    ggthemes::scale_color_calc()+
    ggplot2::annotate("segment", x=-Inf,xend=Inf,y=0,yend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.2,"cm")),size=0.3,color="grey50") +
    ggplot2::annotate("segment", y=-Inf,yend=Inf,x=0,xend=0,arrow=ggplot2::arrow(length=ggplot2::unit(0.2,"cm")),size=0.3,color="grey50")+
    # center (0,0)
    ggplot2::xlim(-max(abs(c(data[,1],data2[,1])))*1.2, max(abs(c(data[,1],data2[,1])))*1.2)+
    ggplot2::ylim(-max(abs(c(data[,2],data2[,2])))*1.2, max(abs(c(data[,2],data2[,2])))*1.2)+
    ggplot2::ggtitle(paste0("Partial Score: Group ",group_num))+ggplot2::labs(x=names[1],y=names[2])
}

#' @title Plot Method for \code{mfa} Object
#' @rdname plot-mfa-method
#' @description Returns plots of eigenvalues, compromise factor scores and partial factor score.
#' @param x a R object of \code{mfa}
#' @param dim a integer vector of two values
#' @param singleoutput a character value among ('eig','com','par') indicating which graph to output
#' @return plots of \code{mfa} Object
#' @export
#' @examples
#' ndatas<-apply(wine,2,function(x){ (x-mean(x))/norm(x-mean(x),type="2")})
#' test<-mfa(ndatas,sets=list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53),
#'           center=FALSE,scale=FALSE)
#' 
#' # default
#' plot(test)
#' 
#' # other dimentions
#' plot(test,dim=c(2,3))
#' 
#' # single output
#' plot(test,singleoutput="eig")
#' plot(test,singleoutput="com")
#' plot(test,singleoutput="par")

setMethod("plot",signature="mfa",
          function(x,dim=c(1,2),singleoutput=NULL){
            if(length(dim)!=2) {stop("dim should be a integer vector of two values.")}
            if(any(!dim%in%1:length(x@eigenvalues))) {stop("dim out of bounds.")}
            if(!is.null(singleoutput)){
              if(!singleoutput%in%c("eig","com","par")) {
                stop("singleoutput can only take a character value among 'eig','com','par'.")
              }
            }

            blankPlot <- ggplot2::ggplot()+ggplot2::geom_blank(ggplot2::aes(1,1))+
              ggplot2::theme(
                plot.background = ggplot2::element_blank(),
                panel.grid.major = ggplot2::element_blank(),
                panel.grid.minor = ggplot2::element_blank(),
                panel.border = ggplot2::element_blank(),
                panel.background = ggplot2::element_blank(),
                axis.title.x = ggplot2::element_blank(),
                axis.title.y = ggplot2::element_blank(),
                axis.text.x = ggplot2::element_blank(),
                axis.text.y = ggplot2::element_blank(),
                axis.ticks = ggplot2::element_blank(),
                axis.line = ggplot2::element_blank()
              )

            sets<-x@sets
            # if sets is character: turn sets into indicies acccording to rownames of data
            if (!is.numeric(sets[[1]])){
              newlist<-list()
              for (i in 1:length(sets)){
                newlist[[i]]<-c(which(rownames(x@loadings)==sets[[i]][1]):which(rownames(x@loadings)==sets[[i]][length(sets[[i]])]))
              }
              sets<-newlist
            }
            names<-sapply(dim,function(x){paste0("Dim",x)})
            partial<-lapply(x@partial_factor_score,function(x){x[,dim]})
            compromise<-data.frame(x@common_factor_score[,dim])
            loadings<--data.frame(x@loadings[,dim])
            eigen<-data.frame("eigen"=x@eigenvalues)
            eigen$id<-sapply(c(1:length(x@eigenvalues)),function(x){paste0("Dim",x)})

            # rescale loading to singular value

            for (i in 1:length(loadings[1,])){
              loadings[,i]<-loadings[,i]*(sqrt(x@eigenvalues[i])/sd(loadings[,i]))
            }

            compromise$id<-rownames(compromise)
            loadings$id<-rownames(loadings)

            # group lable for loadings
            group<-c(rep(0,length(compromise[,1])))
            for (i in 1:length(sets)){
              group[sets[[i]]]<-paste0("Group",i)
            }
            loadings$group<-factor(group, levels = unique(group))

            # plot compromise factor score of the two dimension ##############
            p1<-ggplot2::ggplot()+
              ggplot2::geom_point(data=compromise,ggplot2::aes(x=compromise[,1],y=compromise[,2],color=id),size=3)+
              ggplot2::theme(plot.title = ggplot2::element_text(size=10, face="bold",vjust=1,color="grey40"),
                             axis.title.x = ggplot2::element_text(size=8, face="bold",vjust=-0.5,color="grey40"),
                             axis.title.y = ggplot2::element_text(size=8, face="bold",vjust=0.5,color="grey40"),
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



            # plot barchart for eigenvalues
            p2<-ggplot2::ggplot(data=eigen,ggplot2::aes(x=factor(id,levels=id),y=eigen,fill=factor(id,levels=id)))+
              ggplot2::geom_bar(stat="identity",width=0.5)+
              ggthemes::scale_fill_calc()+
              ggplot2::theme(plot.title = ggplot2::element_text(size=10, face="bold",vjust=1,color="grey40"),
                             axis.title.x = ggplot2::element_text(size=6, face="bold",vjust=-0.5,color="grey40"),
                             axis.title.y = ggplot2::element_text(size=8, face="bold",vjust=0.5,color="grey40"),
                             legend.title=ggplot2::element_blank(),
                             panel.background = ggplot2::element_blank(),
                             panel.grid.minor = ggplot2::element_line(colour = "grey90",size=0.2),
                             panel.grid.major = ggplot2::element_line(colour = "grey90",size=0.2),
                             axis.text.x = ggplot2::element_text(color="grey40",size=6),
                             axis.text.y = ggplot2::element_text(color="grey40",size=8),
                             legend.text=ggplot2::element_text(size=8))+
              ggplot2::ggtitle(paste0("Eigenvalues"))+ggplot2::labs(x="",y="")+
              ggplot2::guides(fill = ggplot2::guide_legend(keywidth = 0.9, keyheight = 0.9))

            # plot partial factor score
            plist <- list()
            for (i in 1:length(sets)){
              data<-data.frame(partial[[i]])
              data[,2]<--data[,2]
              data$id<-rownames(data)
              data2<-loadings[sets[[i]],]
              data2[,1]<--data2[,1]
              plot<-partial_plot(i,data,data2,names)
              plist[[i]]<-plot
            }

            # arrange output
            if (is.null(singleoutput)){
              p3<-do.call(get("arrangeGrob", asNamespace("gridExtra")),c(plist,ncol=5,top=""))
            if (length(sets)==10){
              p<-gridExtra::grid.arrange(blankPlot,p1,p2,p3,ncol=6, nrow=2, widths=c(1,1,1,1,1,1), heights=c(3, 6),layout_matrix = rbind(c(1,3,3,2,2,1), c(4,4,4,4,4,4)))

              jpeg("mfa.jpeg", width = 14, height = 9, units = 'in', res = 1000)
              p
              dev.off()
              print(p)
              cat(" 'mfa.jpeg' is saved in the current folder")
            }else{
              p3<-do.call(get("arrangeGrob", asNamespace("gridExtra")),c(plist,ncol=floor(sqrt(length(sets))),top=""))
            p<-gridExtra::grid.arrange(p1,p2,p3,ncol=3)
            jpeg("mfa.jpeg", width = 14, height = 9, units = 'in', res = 1000)
            gridExtra::grid.arrange(p1,p2,p3,ncol=3)
            dev.off()
            print(p)
            cat(" 'mfa.jpeg' is saved in the current folder")
            }
            }else{

            if (singleoutput=='eig'){
              jpeg("mfa.jpeg", width = 5, height = 5, units = 'in', res = 1000)
              gridExtra::grid.arrange(p2,ncol=1)
              dev.off()
              print(p2)
              cat(" 'mfa.jpeg' is saved in the current folder")
            }
              if (singleoutput=='com'){
                jpeg("mfa.jpeg", width = 5, height = 5, units = 'in', res = 1000)
                gridExtra::grid.arrange(p1,ncol=1)
                dev.off()
                print(p1)
                cat(" 'mfa.jpeg' is saved in the current folder")
              }
              if (singleoutput=='par'){
                jpeg("mfa.jpeg", width = 14, height = 9, units = 'in', res = 1000)
                do.call(get("grid.arrange", asNamespace("gridExtra")),c(plist,ncol=5,top=""))
                dev.off()
                print(do.call(get("grid.arrange", asNamespace("gridExtra")),c(plist,ncol=5,top="")))
                cat(" 'mfa.jpeg' is saved in the current folder")

            }}

          })

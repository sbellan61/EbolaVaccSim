if(grepl('stevebe', Sys.info()['nodename'])) setwd('~/Documents/R Repos/EbolaVaccSim/')
if(grepl('stevebellan', Sys.info()['login'])) setwd('~/Documents/R Repos/EbolaVaccSim/')
if(grepl('tacc', Sys.info()['nodename'])) setwd('/home1/02413/sbellan/VaccEbola/')
library(RColorBrewer); library(data.table); library(ggplot2); library(dplyr); library(grid)
##load(file=file.path('BigResults','powFin.Rdata'))
percent <- function(x) paste0(formatC(x*100), '%')
labs <- c('','log')

thing <- 'FalsePosFluct'
load(file=file.path('Results',paste0('powFin_',thing,'.Rdata')))
pf[vaccEff==.5 & trial=='RCT' & propInTrial==.025 & mod=='CoxME']
source('ggplotTheme.R')
pf$cvWeeklyDecay <- pf[, as.numeric(levels(cvWeeklyDecay)[cvWeeklyDecay])]
pf$weeklyDecay <- pf[, as.numeric(levels(weeklyDecay)[weeklyDecay])]
pf$cvClus <- pf[, as.numeric(levels(cvClus)[cvClus])]
pf$cvClusTime <- pf[, as.numeric(levels(cvClusTime)[cvClusTime])]

####################################################################################################
## them for ms
thax <- element_text(colour = 'black', size = 8)
thsb <- theme(axis.text.x = thax, axis.text.y = thax, plot.title = element_text(vjust=1),
              axis.title.y = element_text(vjust = 1), axis.title.x = element_text(vjust = -.5),
              axis.line = element_line(), axis.ticks = element_line(color='black'),
              panel.margin = unit(1, "lines"), legend.key.height=unit(2,"line")
              , strip.background = element_rect(fill = NA)
              ,legend.position = 'right'
              , axis.line = element_blank()
              ,panel.grid.major = element_blank()
              , panel.grid.minor = element_blank()
              ,panel.border = element_blank()
              ,panel.background = element_blank()
              , legend.background =  element_blank()
              , legend.key =  element_blank()
              , legend.key.width=unit(2,"line")
              ## , strip.text.x = element_text(size=8, angle=75)
              ## , strip.text.y = element_text(size=12)
              ## ,legend.justification=c(1,0), legend.position=c(1,0)
              )
theme_set(theme_grey(base_size = 12))

####################################################################################################
## Figure 2 - Type I errors
 
subs <- pf[,trial %in% c('SWCT','RCT') & vaccEff==0 & mod %in% c('CoxME','bootCoxME','relabCoxME') & immunoDelay==21]
subs <- subs & pf[,!(trial=='RCT' & grepl('boot',mod))]
p.tmp <- ggplot(pf[subs], 
                aes(cvWeeklyDecay, stoppedNAR, colour=trial, linetype=order)) + thsb +
    scale_x_continuous(limits=c(0,1), minor_breaks=NULL, breaks = unique(pf[,cvWeeklyDecay])) +  
    xlab('coef variation of weekly decay rate') + ylab('False Positive Rate') + 
    scale_linetype_manual(breaks=levels(pf$order), values=1:3) +
    geom_hline(yintercept=.05, color='dark gray', size = 1) +
    geom_line(size=1) + facet_wrap(mod ~ cvClusTime, scales='free') + scale_color_manual(values=group.colors)
 p.tmp <- p.tmp + scale_y_continuous(labels = formatC, limits=c(0,.15))
ggsave(paste0('Figures/Fig SX - Type I by fluct & weekly decay CV.pdf'), p.tmp, w = 7.5, h = 5.5)

####################################################################################################
## Figure 2B - Type I errors
for(jj in 1:2) {
thax <- element_text(colour = 'black', size = 8)
subs <- pf[,trial %in% c('SWT','RCT') & vaccEff==0 & mod %in% c('CoxME','bootCoxME','relabCoxME') & immunoDelay==21]
subs <- subs & pf[,!(trial=='RCT' & grepl('boot',mod))]
p.tmp <- ggplot(pf[subs], 
                aes(propInTrial, stoppedNAR, colour=model, linetype=order)) + thsb +
    scale_x_continuous(labels = percent, limits=c(.025,.1), minor_breaks=NULL, breaks = c(.025,.05,.075,.1)) +  
    xlab('% of district-level cases in trial population') + ylab('Type I Error Rate') + 
    scale_linetype_manual(breaks=levels(pf$order), values=1:3) +
    geom_hline(yintercept=.05, color='dark gray', size = 1) +
    geom_line(size=1) + facet_wrap(~trial, scales = "free_y") + 
        scale_color_manual(values=group.colors)
if(jj==1) p.tmp <- p.tmp + scale_y_continuous(labels = formatC, limits=c(0,.15))
if(jj==2) p.tmp <- p.tmp + scale_y_log10(labels = formatC, breaks = c(.01, .025, .05, .1, .25), limits = c(.005,.25), minor_breaks=NULL) 
ggsave(paste0('Figures/Fig 2B -',labs[jj],'Type I SL.png'), p.tmp, w = 6.5, h = 3.5)
ggsave(paste0('Figures/Fig 2B -',labs[jj],'Type I SL.pdf'), p.tmp, w = 6.5, h = 3.5)
}

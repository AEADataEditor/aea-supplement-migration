# Derived from aea201910-migration.Rmd
# Re-generate the software image with different layout, same input data

source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)
source(file.path(programs,"global-libraries.R"), echo=FALSE)

table.aea.software_by_year <- read.csv(file=file.path(generated,"table.aea.software_by_year.csv"))

# now graph it


# graph percent
table.aea.software_by_year %>%
	filter(year>2009) %>%
	rename(Software = Software_collapsed) %>%
	ggplot(aes(year,Percent)) +
		geom_line(aes(color=Software,linetype=Software), linewidth=1.2) +
	    ylab(element_blank())+
	    xlab("Software, Percentage of packages") +
	    ylab(element_blank()) +
	    theme_classic(base_size = 16) +
	    scale_colour_brewer(palette = "Paired") +
	    scale_x_continuous(limits=c(2010,max(table.aea.software_by_year$year)),breaks=seq(2010,max(table.aea.software_by_year$year),2)) +
	    theme(axis.line = element_line(linewidth=0),
	    	  axis.title.y = element_text(angle=0),
	    	  axis.text = element_text(size=12),
	    	  axis.title = element_blank(),
	    	  legend.text = element_text(size=11),
	    	  legend.title = element_blank(),
	    	  legend.key.width = unit(2, "cm"),
	    	  legend.key.height = unit(0.8, "cm")) -> fig.software_by_year.pct
ggsave(file.path(programs,"figure_software_years_pct.png"),fig.software_by_year.pct,
       width=6.5, height=3.5, units="in", dpi=300)


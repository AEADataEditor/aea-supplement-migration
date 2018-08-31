clear
set more off 
clear matrix
set mem 500m
global data_path=""

use "${data_path}/replication_panel", clear
  
************
* Controls *
************
set more off  
xtset hhid wave 

global hh_controls hh_age_head hh_female_head i.hh_men_16_59 i.hh_women_16_59 i.hh_dep hh_men_60_over hh_women_60_over hh_child_6_15 hh_child_0_5

* MAIN TABLES:

***********
* Table 1 *
***********

global sample "wave==2 & hh_dep!=."
su hh_men_16_59 hh_women_16_59 hh_dep if ${sample}
su hh_main_occu_farm hh_age_head hh_school_head hh_female_head if ${sample}
su cap_inc_net cap_inc_crop cap_inc_selfempl cap_inc_labor cap_inc_third cap_inc_remit_relative if ${sample}
su cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health if ${sample}
su cap_borrowing cap_savings if ${sample}
su mig_all cap_remit_net_all mig_outdistrict cap_remit_net_outdistrict mig_district cap_remit_net_district if ${sample}

global sample "wave==2 & province_id==405 & hh_dep!=."
su hh_men_16_59 hh_women_16_59 hh_dep if ${sample}
su hh_main_occu_farm hh_age_head hh_school_head hh_female_head if ${sample}
su cap_inc_net cap_inc_crop cap_inc_selfempl cap_inc_labor cap_inc_third cap_inc_remit_relative if ${sample}
su cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health if ${sample}
su cap_borrowing cap_savings if ${sample}
su mig_all cap_remit_net_all mig_outdistrict cap_remit_net_outdistrict mig_district cap_remit_net_district if ${sample}

global sample "wave==2 & province_id==411 & hh_dep!=. & cap_inc_net>-30000"
su hh_men_16_59 hh_women_16_59 hh_dep if ${sample}
su hh_main_occu_farm hh_age_head hh_school_head hh_female_head if ${sample}
su cap_inc_net cap_inc_crop cap_inc_selfempl cap_inc_labor cap_inc_third cap_inc_remit_relative if ${sample}
su cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health if ${sample}
su cap_borrowing cap_savings if ${sample}
su mig_all cap_remit_net_all mig_outdistrict cap_remit_net_outdistrict mig_district cap_remit_net_district if ${sample}

global sample "wave==2 & province_id==605 & hh_dep!=."
su hh_men_16_59 hh_women_16_59 hh_dep if ${sample}
su hh_main_occu_farm hh_age_head hh_school_head hh_female_head if ${sample}
su cap_inc_net cap_inc_crop cap_inc_selfempl cap_inc_labor cap_inc_third cap_inc_remit_relative if ${sample}
su cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health if ${sample}
su cap_borrowing cap_savings if ${sample}
su mig_outdistrict cap_remit_net_outdistrict mig_district cap_remit_net_district if ${sample}

***********
* Table 2 *
***********

global sample "wave!=1 & cap_inc_net!=."

foreach var of varlist cap_inc_net cap_inc_crop cap_inc_crop_rice_pad_SA cap_inc_crop_rice_pad_W{
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}

global sample "wave!=1"

foreach var of varlist cap_con_total cap_con_food cap_con_non_food cap_con_healthedu{
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}  


***********
* Table 3 *
***********

global sample "wave!=1 & cap_inc_net!=."

foreach var of varlist cap_inc_livestock cap_inc_hunt cap_inc_labor cap_inc_selfempl {
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}
 
***********
* Table 4 *
***********

global sample "wave!=1"

foreach var of varlist cap_remit_net_district cap_remit_net_outdistrict cap_remit_net_outprovince{
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}	

***********
* Table 5 *
***********

global sample "wave!=1"

foreach var of varlist cap_remit_net_nonlabor cap_transf_net_all cap_inc_pubtrans cap_inc_indem{
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}

global sample "wave!=1"

foreach var of varlist cap_assets cap_npv_tangible_assets{
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}
 
***********
* Table 6 *
***********

global sample "wave!=1 & !sample_mig_district"

foreach var of varlist cap_remit_net_district mig_district {
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}

global sample "wave!=1 & !sample_mig_outdistrict"

foreach var of varlist cap_remit_net_outdistrict mig_outdistrict {
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}

global sample "wave!=1 & sample_mig_district"

foreach var of varlist cap_remit_net_district mig_district {
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}

global sample "wave!=1 & sample_mig_outdistrict"

foreach var of varlist cap_remit_net_outdistrict mig_outdistrict {
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}
  
***********
* Table 7 *
***********

xi: reg treat_aft_5 prop_5 i.province_id if wave==3 
predict res, resid

egen treat_mean=sum(res) if wave==3 & res!=., by(hhid)
generate treated=1 if treat_mean>0.017 & treat_mean!=.
replace treated=0 if treat_mean<0.017 & treat_mean!=.
egen treated_all=total(treated), by(hhid) missing
 
global sample "wave==3"

ttest inc_1m_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest indser_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest inc_1m_indser_mig_outdistrict if inc_1m_indser_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest agr_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest inc_1m_agr_job_mig_outdistrict if inc_1m_agr_job_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest pub_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest inc_1m_pub_job_mig_outdistrict if inc_1m_pub_job_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest mean_age_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest mean_sex_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest mean_edu_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest mean_loca_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest perm_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest good_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest rapid_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 
ttest mean_search_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict)
ttest info_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(sample_mig_outdistrict) 

global sample "wave==3 & !sample_mig_outdistrict"

ttest inc_1m_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest indser_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest inc_1m_indser_mig_outdistrict if inc_1m_indser_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest agr_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest inc_1m_agr_job_mig_outdistrict if inc_1m_agr_job_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest pub_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest inc_1m_pub_job_mig_outdistrict if inc_1m_pub_job_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest mean_age_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest mean_sex_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest mean_edu_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest mean_loca_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest perm_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest good_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest rapid_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 
ttest mean_search_job_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all)
ttest info_mig_outdistrict if inc_1m_mig_outdistrict!=0 & ${sample}, by(treated_all) 

* APPENDIX:

************
* Table A1 *
************

global sample "wave!=3 & cap_remit_net_outdistrict!=. & cap_con_total!=. "

foreach var of varlist cap_inc_net cap_con_total mig_district cap_remit_net_district mig_outdistrict cap_remit_net_outdistrict mig_outprovince cap_remit_net_outprovince {
foreach rad in 5 {
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}
}

***********
* Table A2*
***********

global sample "wave==2 & cap_inc_net!=."

* Income

foreach var of varlist cap_inc_net cap_inc_crop cap_inc_selfempl cap_inc_labor cap_inc_third {
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

global sample "wave==2 & cap_con_total!=."

* Consumption

foreach var of varlist cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

* Migration

foreach var of varlist mig_district cap_remit_net_district mig_outdistrict cap_remit_net_outdistrict mig_outprovince cap_remit_net_outprovince {
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

global sample "wave==2 & cap_inc_net!=."

* Other instruments

foreach var of varlist cap_transf_net_all cap_savings cap_borrowing{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

* Migrants characteristics

foreach var of varlist mig_outdistrict {
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

foreach var of varlist cap_inc_mig_outdistrict mean_age_job_mig_outdistrict mean_sex_job_mig_outdistrict mean_edu_job_mig_outdistrict{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample} & mig_outdistrict, vce(cluster subdistrict_id)
}


************
* Table A3 *
************

global sample "wave!=1 & cap_remit_net_outprovince!=."

foreach var of varlist cap_inc_net{
xi: xtreg `var' treat_rain_w3 i.wave*rain_mean_2008 i.wave*rain_mean_2007 i.wave*i.province_id ${hh_controls} if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
xi: xtivreg `var' (treat_aft_5_w3=treat_rain_w3) i.wave*rain_mean_2008 i.wave*rain_mean_2007 i.wave*prop_5 i.wave*i.province_id ${hh_controls} if ${sample}, fe i(hhid)
}

global sample "wave!=1 & cap_remit_net_outprovince!=."

foreach var of varlist cap_remit_net_district cap_remit_net_outdistrict cap_remit_net_outprovince{
xi: xtreg `var' i.wave*treat_rain i.wave*rain_mean_2008 i.wave*rain_mean_2007 i.wave*i.province_id ${hh_controls} if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
xi: xtivreg `var' (treat_aft_5_w3=treat_rain_w3) i.wave*rain_mean_2008 i.wave*rain_mean_2007 i.wave*prop_5 i.wave*i.province_id ${hh_controls} if ${sample}, fe i(hhid)
}

global sample "wave!=1 & cap_remit_net_outprovince!=."

foreach rad in 5 {
xi: xtreg treat_aft_5_w3 treat_rain_w3 i.wave*prop_5 i.wave*rain_mean_2008 i.wave*rain_mean_2007 i.wave*i.province_id ${hh_controls} if ${sample}, fe i(hhid)
}
test treat_rain_w3
  
************
* Table A4 *
************

global sample "wave!=1"

foreach var of varlist cap_inc_net cap_remit_net_district cap_remit_net_outdistrict cap_remit_net_outprovince{
foreach rad in 5 {
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*vill_geo_coast i.wave*vill_geo_river i.wave*vill_geo_mountain i.wave*vill_geo_slope i.wave*vill_geo_plain i.wave*vill_geo_valley i.wave*vill_geo_lake i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*area_affected_50 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*rain_mean_2008 i.wave*rain_mean_2007 i.wave*rain_mean_01_08 i.wave*rain_var_01_08 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
}
}

global sample "wave!=1"
foreach var of varlist cap_remit_net_district_90 cap_remit_net_outdistrict_90 cap_remit_net_outprovince_90{
foreach rad in 5 {
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
}
}

************
* Table A5 *
************

global sample "wave!=1"

foreach var of varlist log_cap_inc_net ncap_remit_net_district ncap_remit_net_outdistrict ncap_remit_net_outprovince{
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, cluster(subdistrict_id)			
xi: reg `var' i.wave*treat_aft_5 treat_aft_5 i.wave*prop_5 prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample} & attrition_3==0, cluster(subdistrict_id)			
xi: xtreg `var' i.wave*treat_aft_5 i.wave*prop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)		
}


************
* Table A6 *
************

generate xtreat_aft_5=sample_mig_outdistrict*treat_aft_5 
generate xprop_5=sample_mig_outdistrict*prop_5

global sample "wave!=1 & cap_inc_net!=."

foreach var of varlist cap_inc_net cap_inc_crop {
foreach rad in 5 {
xi: xtreg `var' i.wave*treat_aft_5 i.wave*xtreat_aft_5 i.wave*prop_5 i.wave*xprop_5 i.wave*i.province_id ${hh_controls} [pw=weight] if ${sample}, fe i(hhid) vce(cluster subdistrict_id)
}
}

************
* Table A7 *
************

global sample "wave==2 & cap_inc_net!=. & sample_mig_outdistrict"
foreach var of varlist cap_inc_net cap_inc_crop_rice_pad cap_inc_selfempl cap_inc_labor cap_inc_third {
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

global sample "wave==2 & sample_mig_outdistrict"
foreach var of varlist cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}
foreach var of varlist cap_remit_net_district cap_remit_net_outdistrict cap_remit_net_outprovince{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}
foreach var of varlist cap_borrowing cap_savings{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

global sample "wave==2 & cap_inc_tot!=. & !sample_mig_outdistrict"
foreach var of varlist cap_inc_net cap_inc_crop_rice_pad cap_inc_selfempl cap_inc_labor cap_inc_third {
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

global sample "wave==2 & !sample_mig_outdistrict"
foreach var of varlist cap_con_total cap_con_food cap_con_non_food cap_con_edu cap_con_health{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}
foreach var of varlist cap_remit_net_district cap_remit_net_outdistrict cap_remit_net_outprovince{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}
foreach var of varlist cap_borrowing cap_savings{
xi: reg `var' treat_aft_5 prop_5 i.province_id ${hh_controls} [pw=weight] if ${sample}, vce(cluster subdistrict_id)
}

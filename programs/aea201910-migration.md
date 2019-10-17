# Migrating historical AEA supplements - DRAFT

![](https://www.aeaweb.org/assets/8e0b7bf8/images/logo.svg)
![](https://www.icpsr.umich.edu/icpsrweb/ICPSR/images/open-icpsr-400.png)





Since July 16, 2019, the American Economic Association has used the **[AEA Data and Code Repository](https://www.openicpsr.org/openicpsr/aea)** at **[openICPSR](https://www.openicpsr.org/openicpsr/)** as the default archive for its supplements. This archive serves a dual purpose: to share data with the AEA Data Editor prior to being published, and as a publication outlet for supplements to articles in AEA journals.

At the time, the AEA also announced that it would  migrate the historical supplements, hitherto stored as ZIP files on the [AEA website](https://www.aeaweb.org/journals), into the AEA Data and Code Repository. 

On Oct 1, 2019, openICPSR had 867 deposits, which covered 94 deposits in the [DataLumos](https://www.datalumos.org/datalumos/search/studies) archive, 46 in the [AERA archive](https://www.openicpsr.org/openicpsr/search/aerajournals/studies), and 13 in the [PSID](https://www.openicpsr.org/openicpsr/search/psid/studies) archive. The **AEA Data and Code Repository** contained at the time 93 deposits, of which 5 were public, the others awaiting publication of the associated article. 

Between Oct 11 and Oct 13, 2019, the staff at openICPSR ingested 2,552 historical supplements, increasing the size of the openICPSR repository **by a factor of 3**, to 3,461. This was only the first part of the migration, as there are about 1,000 more archives that need to be migrated.

## Characteristics of AEA supplement data
We can describe this subset of the historical supplements in a variety of ways. 

### Number of files per supplement
<table class="table table-striped table-hover table-condensed" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> doi </th>
   <th style="text-align:right;"> size </th>
   <th style="text-align:right;"> count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 10.1257/pandp.20181045 </td>
   <td style="text-align:right;"> 32782817227 </td>
   <td style="text-align:right;"> 795 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/pol.20150168 </td>
   <td style="text-align:right;"> 27251086584 </td>
   <td style="text-align:right;"> 691 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/app.20170080 </td>
   <td style="text-align:right;"> 19924915397 </td>
   <td style="text-align:right;"> 236 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/aer.20131496 </td>
   <td style="text-align:right;"> 15688843069 </td>
   <td style="text-align:right;"> 186 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/app.20160510 </td>
   <td style="text-align:right;"> 14419727617 </td>
   <td style="text-align:right;"> 465 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/app.6.3.206 </td>
   <td style="text-align:right;"> 12190878093 </td>
   <td style="text-align:right;"> 45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/aer.102.2.994 </td>
   <td style="text-align:right;"> 10789428265 </td>
   <td style="text-align:right;"> 36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/aer.20121662 </td>
   <td style="text-align:right;"> 10334181612 </td>
   <td style="text-align:right;"> 622 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/mic.20130164 </td>
   <td style="text-align:right;"> 8042445763 </td>
   <td style="text-align:right;"> 20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10.1257/aer.20141374 </td>
   <td style="text-align:right;"> 6804364827 </td>
   <td style="text-align:right;"> 140 </td>
  </tr>
</tbody>
</table>

The 2,552 supplements contain a total of 94,465 files - programs, documents, datasets. The largest supplement within this group in terms of file count has 795 files, summing to 30.5 Gb [(Armour, Button, and Hollands, 2018)](https://doi.org/10.1257/pandp.20181045). Note however that among the remaining non-migrated supplements are very large packages: the largest we have identified has 201,972 files. 



### Distribution by journal
First, we can look at the size of the supplements globally by journal. The following table shows cumulative and median size and number of files.

<table class="table table-striped table-hover table-condensed" style="width: auto !important; float: right; margin-left: 10px;">
 <thead>
  <tr>
   <th style="text-align:left;"> Journal </th>
   <th style="text-align:right;"> Median Size (Mb) </th>
   <th style="text-align:right;"> Cumulative Size (Mb) </th>
   <th style="text-align:right;"> Median files </th>
   <th style="text-align:right;"> Total files </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> American Economic Review </td>
   <td style="text-align:right;"> 1.3 </td>
   <td style="text-align:right;"> 165,547.8 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 50,163 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Economic Journal: Applied Economics </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:right;"> 101,969.8 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 9,979 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Economic Journal: Economic Policy </td>
   <td style="text-align:right;"> 4.2 </td>
   <td style="text-align:right;"> 98,574.0 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 12,585 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AEA Papers and Proceedings </td>
   <td style="text-align:right;"> 0.9 </td>
   <td style="text-align:right;"> 44,497.3 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2,589 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Economic Journal: Macroeconomics </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 14,943.2 </td>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:right;"> 10,231 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Economic Journal: Microeconomics </td>
   <td style="text-align:right;"> 1.1 </td>
   <td style="text-align:right;"> 12,898.8 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 5,423 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Journal of Economic Perspectives </td>
   <td style="text-align:right;"> 0.8 </td>
   <td style="text-align:right;"> 12,755.7 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 2,833 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Journal of Economic Literature </td>
   <td style="text-align:right;"> 17.8 </td>
   <td style="text-align:right;"> 431.8 </td>
   <td style="text-align:right;"> 67 </td>
   <td style="text-align:right;"> 559 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Economic Review: Insights </td>
   <td style="text-align:right;"> 8.2 </td>
   <td style="text-align:right;"> 74.7 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 103 </td>
  </tr>
</tbody>
</table>
### Distribution across JEL codes

The top 10 JEL codes associated with supplements are:

<table class="table table-striped table-hover table-condensed" style="width: auto !important; float: right; margin-left: 10px;">
 <thead>
  <tr>
   <th style="text-align:right;"> Number of packages </th>
   <th style="text-align:right;"> Pct </th>
   <th style="text-align:left;"> JEL </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 263 </td>
   <td style="text-align:right;"> 10.31 </td>
   <td style="text-align:left;"> E32 </td>
   <td style="text-align:left;"> Business Fluctuations; Cycles </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 245 </td>
   <td style="text-align:right;"> 9.60 </td>
   <td style="text-align:left;"> J24 </td>
   <td style="text-align:left;"> Human Capital; Skills; Occupational Choice; Labor Productivity </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 217 </td>
   <td style="text-align:right;"> 8.50 </td>
   <td style="text-align:left;"> O15 </td>
   <td style="text-align:left;"> Economic Development: Human Resources; Human Development; Income Distribution; Migration </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 214 </td>
   <td style="text-align:right;"> 8.39 </td>
   <td style="text-align:left;"> D12 </td>
   <td style="text-align:left;"> Consumer Economics: Empirical Analysis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 207 </td>
   <td style="text-align:right;"> 8.11 </td>
   <td style="text-align:left;"> J31 </td>
   <td style="text-align:left;"> Wage Level and Structure; Wage Differentials </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 191 </td>
   <td style="text-align:right;"> 7.48 </td>
   <td style="text-align:left;"> J16 </td>
   <td style="text-align:left;"> Economics of Gender; Non-labor Discrimination </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 183 </td>
   <td style="text-align:right;"> 7.17 </td>
   <td style="text-align:left;"> J13 </td>
   <td style="text-align:left;"> Fertility; Family Planning; Child Care; Children; Youth </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 176 </td>
   <td style="text-align:right;"> 6.90 </td>
   <td style="text-align:left;"> I21 </td>
   <td style="text-align:left;"> Analysis of Education </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 162 </td>
   <td style="text-align:right;"> 6.35 </td>
   <td style="text-align:left;"> D72 </td>
   <td style="text-align:left;"> Political Processes: Rent-seeking, Lobbying, Elections, Legislatures, and Voting Behavior </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 157 </td>
   <td style="text-align:right;"> 6.15 </td>
   <td style="text-align:left;"> D83 </td>
   <td style="text-align:left;"> Search; Learning; Information and Knowledge; Communication; Belief </td>
  </tr>
</tbody>
<tfoot>
<tr><td style="padding: 0; border: 0;" colspan="100%"><span style="font-style: italic;">Note: </span></td></tr>
<tr><td style="padding: 0; border: 0;" colspan="100%">
<sup></sup> *A supplement can be associated with multiple JEL codes.*</td></tr>
</tfoot>
</table>



 
 

## Metadata 
When planning the migration, the preservation of existing metadata - the information about the data and code - was important. The AEA Data Editor worked with the openICPSR staff to enhance the data infrastructure, adding the capability to store and display JEL codes in addition to subject terms.  Going forward, in addition to adding the JEL codes that also describe the linked article, authors can add metadata such as *geographic coverage*, *funding sources*, *time periods*, *geographic units* as well as *units of observation*, greatly enhancing the ability of researchers to find data through the openICPSR search interface. 

Two important caveats apply, however. First, none of the additional metadata exists for the historical archives. Second, the openICPSR search interface does not currently expose the ability to search by those fields. An enhancement is planned for implementation before the end of 2019.

## References




# get QSQ/Elevon/netstore customer files
1 5 * * * ftp 172.16.200.33

# apply the customer balances to the DB
5 7 * * * /home/chd/do_accounts_balances.sh

# -- Order process starts here....
# Partition orders into product groups every minute
# at 15 second intervals
*/1 0-23 * * *  /home/chd/chd3backend/partition.sh
*/1 0-23 * * *  /home/chd/chd3backend/partition15.sh
*/1 0-23 * * *  /home/chd/chd3backend/partition30.sh
*/1 0-23 * * *  /home/chd/chd3backend/partition45.sh

# Generate products mon-sun 7am->midnight every minute
*/1 0-23 * * *  /home/chd/chd3backend/reports.sh
*/1 0-23 * * *  /home/chd/chd3backend/images.sh
*/1 0-23 * * *  /home/chd/chd3backend/packages.sh
*/1 0-23 * * *  /home/chd/chd3backend/scud.sh
*/1 0-23 * * *  /home/chd/chd3backend/fiche.sh
# Monitor turned of 9 May 2019 11:20 - TJ
#*/1 0-23 * * *  /home/chd/chd3backend/monitor.sh
*/1 0-23 * * *  /home/chd/chd3backend/invoice.sh
*/1 0-23 * * *  /home/chd/chd3backend/jobsheet.sh

#SR*/1 0-23 * * *  /home/chd/chd3backend/fax.sh
*/1 0-23 * * *  /home/chd/chd3backend/internal.sh

# Scan for and record Fax delivery status to CH report dir and to Database
#SR*/5 0-23 * * *  /home/chd/chd3backend/faxStatus.sh
*/5 * * * * /home/chd/chd3backend/ORAerror.sh

# ----------------------------------------------------------------------
# DO NOT run these unless there is a problem on chdtux1
# Process monitor Matches/renewals and send out emails etc
#30 9 * * *  /home/chd/chd3backend/monitorMatch.sh
#30 11 * * *  /bin/grep "Monitor emails" $HOME/backend.log > /tmp/monConf.txt
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# DO NOT run these unless there is a problem on chdtux1
#*/10 * * * *  /home/chd/chd3backend/weedall.sh chd3
# Weed the Image system 2000-2359 and 0000-0359
#*/5 18-23 * * *  /home/chd/chd3backend/weedDocs.sh
#*/5 0-5 * * *  /home/chd/chd3backend/weedDocs.sh
# ----------------------------------------------------------------------

# make sure that there are no lock files hanging around for
# for more than 8 mins
*/10 6-23 * * * /home/chd/chd3backend/monitorLockChecker.sh
# -- Order process Ends here.
# ----------------------------------------------------------------------

##########STATS GENERATION USING EFBACKEND#######
05 1 1 * * /home/chd/efbackend/produceStats.sh FreeProductsStatsReport "sbowen@companieshouse.gov.uk,rcooper@companieshouse.gov.uk,aharcombe@companieshouse.gov.uk" month
#SR59 12 * * * /home/chd/efbackend/produceStats.sh FreeProductsStatsReport "rcooper@companieshouse.gov.uk,sreadman@companieshouse.gov.uk" 20210701000000 20210731235959
05 8 * * 1 /home/chd/efbackend/produceStats.sh LPProductsStatsReport "rturner@companieshouse.gov.uk" week
45 10 * * 1 /home/chd/efbackend/produceStats.sh LPProductsStatsReport "rturner@companieshouse.gov.uk" week
15 14 * * * /home/chd/efbackend/produceStats.sh LPProductsStatsReport "dcornelius@companieshouse.gov.uk" week
59 0 * * *  /home/chd/CHDdownloadStats.sh
#################################################

# Start and Stop CHD3
#0  7  * * *  /home/chd/chd3backend/startCHD.sh
#59 23 * * *  /home/chd/chd3backend/stopCHD.sh

# Produce dump of CHD3 accounts so that they may be backported into CHD2, obelix gets this file
30 20 * * 1-6   /home/chd/chd3-chd2/unload.sh

# scripts to expire Empirix test accounts document records, so that weeding will delete them
10 0,4,8,12,16,20 * * * /home/chd/chd3backend/expireEmpirixDocs.sh

# scripts to expire Empirix test accounts order records, so that weeding will delete them
20 0,4,8,12,16,20 * * * /home/chd/chd3backend/expireEmpirixOrders.sh

# script that mails weekly monitor totals to MIU
# turned off 27/04/2020
#25 6 * * 1 /home/chd/chd3backend/getMonitorTotals.sh

#INC0294077
0 8,9,10,11,12,13,14,15,16,17,18 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh

# special one at end of day to catch any after 6pm
59 23 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh
#sr20 15 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh
#sr40 15 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh
59 23 * * *   /home/chd/chd3backend/getFHDOCorders.sh

#INC0042846 - request to change run time
00 11 * * 1-5 /home/chd/chd3backend/getTotalFicheOrders.sh
12 11 * * 1-5 /home/chd/chd3backend/getTotalFicheOrders.sh
#30 10 * * 1-5 /home/chd/chd3backend/getBULKFicheOrders.sh # Changed as requested by GHI
05 11 * * 1-5 /home/chd/chd3backend/getBULKFicheOrders.sh # Changed as requested by GHI
#0 6 * * 0,3 /home/chd/chd3backend/secretsquirrel.sh
*/5 * * * * /home/chd/chd3backend/ORAerror.sh

# Job to clear down the robot account download area on a daily basis.
#SR01 0,4,8,12,16,20 * * * find /mnt/ha/image/79/15/57 -type f -mtime +1 -exec rm -f {} \;
01 0,4,8,12,16,20 * * * find /mnt/nfs/chd/image/79/15/57 -type f -mtime +1 -exec rm -f {} \;
30 23 * * * /home/chd/chd3backend/chd-cleanup.sh
25 21 * * * /home/chd/chd3backend/chd-cleanup.sh

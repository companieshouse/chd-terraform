#LIVE# get QSQ/Elevon/netstore customer files
#LIVE1 5 * * * ftp 172.16.200.33

#LIVE# apply the customer balances to the DB
#LIVE5 7 * * * /home/chd/do_accounts_balances.sh

#LIVE# -- Order process starts here....
#LIVE# Partition orders into product groups every minute
#LIVE# at 15 second intervals
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/partition.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/partition15.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/partition30.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/partition45.sh

#LIVE# Generate products mon-sun 7am->midnight every minute
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/reports.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/images.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/packages.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/scud.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/fiche.sh
#LIVE# Monitor turned of 9 May 2019 11:20 - TJ
#LIVE#*/1 0-23 * * *  /home/chd/chd3backend/monitor.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/invoice.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/jobsheet.sh

#LIVE#SR*/1 0-23 * * *  /home/chd/chd3backend/fax.sh
#LIVE*/1 0-23 * * *  /home/chd/chd3backend/internal.sh

#LIVE# Scan for and record Fax delivery status to CH report dir and to Database
#LIVE#SR*/5 0-23 * * *  /home/chd/chd3backend/faxStatus.sh
#LIVE*/5 * * * * /home/chd/chd3backend/ORAerror.sh

#LIVE# ----------------------------------------------------------------------
#LIVE# DO NOT run these unless there is a problem on chdtux1
#LIVE# Process monitor Matches/renewals and send out emails etc
#LIVE#30 9 * * *  /home/chd/chd3backend/monitorMatch.sh
#LIVE#30 11 * * *  /bin/grep "Monitor emails" $HOME/backend.log > /tmp/monConf.txt
#LIVE# ----------------------------------------------------------------------

#LIVE# ----------------------------------------------------------------------
#LIVE# DO NOT run these unless there is a problem on chdtux1
#LIVE#*/10 * * * *  /home/chd/chd3backend/weedall.sh chd3
#LIVE# Weed the Image system 2000-2359 and 0000-0359
#LIVE#*/5 18-23 * * *  /home/chd/chd3backend/weedDocs.sh
#LIVE#*/5 0-5 * * *  /home/chd/chd3backend/weedDocs.sh
#LIVE# ----------------------------------------------------------------------

#LIVE# make sure that there are no lock files hanging around for
#LIVE# for more than 8 mins
#LIVE*/10 6-23 * * * /home/chd/chd3backend/monitorLockChecker.sh
#LIVE# -- Order process Ends here.
#LIVE# ----------------------------------------------------------------------

#LIVE##########STATS GENERATION USING EFBACKEND#######
#LIVE05 1 1 * * /home/chd/efbackend/produceStats.sh FreeProductsStatsReport "sbowen@companieshouse.gov.uk,rcooper@companieshouse.gov.uk,aharcombe@companieshouse.gov.uk" month
#LIVE#SR59 12 * * * /home/chd/efbackend/produceStats.sh FreeProductsStatsReport "rcooper@companieshouse.gov.uk,sreadman@companieshouse.gov.uk" 20210701000000 20210731235959
#LIVE05 8 * * 1 /home/chd/efbackend/produceStats.sh LPProductsStatsReport "rturner@companieshouse.gov.uk" week
#LIVE45 10 * * 1 /home/chd/efbackend/produceStats.sh LPProductsStatsReport "rturner@companieshouse.gov.uk" week
#LIVE15 14 * * * /home/chd/efbackend/produceStats.sh LPProductsStatsReport "dcornelius@companieshouse.gov.uk" week
#LIVE59 0 * * *  /home/chd/CHDdownloadStats.sh
#LIVE#################################################

#LIVE# Start and Stop CHD3
#LIVE#0  7  * * *  /home/chd/chd3backend/startCHD.sh
#LIVE#59 23 * * *  /home/chd/chd3backend/stopCHD.sh

#LIVE# Produce dump of CHD3 accounts so that they may be backported into CHD2, obelix gets this file
#LIVE30 20 * * 1-6   /home/chd/chd3-chd2/unload.sh

#LIVE# scripts to expire Empirix test accounts document records, so that weeding will delete them
#LIVE10 0,4,8,12,16,20 * * * /home/chd/chd3backend/expireEmpirixDocs.sh

#LIVE# scripts to expire Empirix test accounts order records, so that weeding will delete them
#LIVE20 0,4,8,12,16,20 * * * /home/chd/chd3backend/expireEmpirixOrders.sh

#LIVE# script that mails weekly monitor totals to MIU
#LIVE# turned off 27/04/2020
#LIVE#25 6 * * 1 /home/chd/chd3backend/getMonitorTotals.sh

#LIVE#INC0294077
#LIVE0 8,9,10,11,12,13,14,15,16,17,18 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh

#LIVE# special one at end of day to catch any after 6pm
#LIVE59 23 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh
#LIVE#sr20 15 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh
#LIVE#sr40 15 * * 1-5 /home/chd/chd3backend/getCHDFicheOrders.sh
#LIVE59 23 * * *   /home/chd/chd3backend/getFHDOCorders.sh

#LIVE#INC0042846 - request to change run time
#LIVE00 11 * * 1-5 /home/chd/chd3backend/getTotalFicheOrders.sh
#LIVE12 11 * * 1-5 /home/chd/chd3backend/getTotalFicheOrders.sh
#LIVE#30 10 * * 1-5 /home/chd/chd3backend/getBULKFicheOrders.sh # Changed as requested by GHI
#LIVE05 11 * * 1-5 /home/chd/chd3backend/getBULKFicheOrders.sh # Changed as requested by GHI
#LIVE#0 6 * * 0,3 /home/chd/chd3backend/secretsquirrel.sh
#LIVE*/5 * * * * /home/chd/chd3backend/ORAerror.sh

#LIVE# Job to clear down the robot account download area on a daily basis.
#LIVE#SR01 0,4,8,12,16,20 * * * find /mnt/ha/image/79/15/57 -type f -mtime +1 -exec rm -f {} \;
#LIVE01 0,4,8,12,16,20 * * * find /mnt/nfs/chd/image/79/15/57 -type f -mtime +1 -exec rm -f {} \;
#LIVE30 23 * * * /home/chd/chd3backend/chd-cleanup.sh
#LIVE25 21 * * * /home/chd/chd3backend/chd-cleanup.sh

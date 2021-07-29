# DO NOT EDIT THIS FILE - edit the master and reinstall.
# (/tmp/crontab.9954 installed on Fri Jun 25 11:15:36 2004)
# (Cron version -- $Id: crontab.c,v 2.13 1994/01/17 03:20:37 vixie Exp $)
## min hour day month weekday
## get QSQ/Elevon/netstore customer files
#LIVE1 5 * * * ftp 172.16.200.33
#
# apply the customer balances to the DB
#LIVE5 7 * * * /home/chd3beplive/do_accounts_balances.sh
#
## -- Order process starts here....
#
# Partition orders into product groups every minute
# at 15 second intervals
#
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/partition.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/partition15.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/partition30.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/partition45.sh

# Generate products mon-sun 7am->midnight every minute
#
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/reports.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/images.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/packages.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/scud.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/fiche.sh
# Monitor turned of 9 May 2019 11:20 - TJ
#LIVE#*/1 0-23 * * *  /home/chd3beplive/chd3backend/monitor.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/invoice.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/jobsheet.sh

#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/fax.sh
#LIVE*/1 0-23 * * *  /home/chd3beplive/chd3backend/internal.sh

# Scan for and record Fax delivery status to CH report dir and to Database
#LIVE*/5 0-23 * * *  /home/chd3beplive/chd3backend/faxStatus.sh
#LIVE*/5 * * * * /home/chd3beplive/chd3backend/ORAerror.sh
# ----------------------------------------------------------------------
# DO NOT run these unless there is a problem on chdtux1
# Process monitor Matches/renewals and send out emails etc
#LIVE#30 9 * * *  /home/chd3beplive/chd3backend/monitorMatch.sh
#LIVE#30 11 * * *  /bin/grep "Monitor emails" $HOME/backend.log > /tmp/monConf.txt
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# DO NOT run these unless there is a problem on chdtux1
#LIVE*/10 * * * *  /home/chd3beplive/chd3backend/weedall.sh chd3
# Weed the Image system 2000-2359 and 0000-0359
#
#LIVE*/5 18-23 * * *  /home/chd3beplive/chd3backend/weedDocs.sh
#LIVE*/5 0-5 * * *  /home/chd3beplive/chd3backend/weedDocs.sh
# ----------------------------------------------------------------------

# make sure that there are no lock files hanging around for
# for more than 8 mins
#LIVE*/10 6-23 * * * /home/chd3beplive/chd3backend/monitorLockChecker.sh

# -- Order process Ends here.
# ----------------------------------------------------------------------
#################################################
##########STATS GENERATION USING EFBACKEND#######
#LIVE05 1 1 * * /home/chd3beplive/efbackend/produceStats.sh FreeProductsStatsReport "sbowen@companieshouse.gov.uk,rcooper@companieshouse.gov.uk,aharcombe@companieshouse.gov.uk" month
#LIVE05 8 * * 1 /home/chd3beplive/efbackend/produceStats.sh LPProductsStatsReport "rturner@companieshouse.gov.uk" week
#LIVE45 10 * * 1 /home/chd3beplive/efbackend/produceStats.sh LPProductsStatsReport "rturner@companieshouse.gov.uk" week
#LIVE15 14 * * * /home/chd3beplive/efbackend/produceStats.sh LPProductsStatsReport "dcornelius@companieshouse.gov.uk" week
#LIVE59 0 * * *  /home/chd3beplive/CHDdownloadStats.sh
#################################################

# Start and Stop CHD3
#LIVE#0  7  * * *  /home/chd3beplive/chd3backend/startCHD.sh
#LIVE#59 23 * * *  /home/chd3beplive/chd3backend/stopCHD.sh

# Produce dump of CHD3 accounts so that they may be backported into CHD2, obelix gets this file
#LIVE30 20 * * 1-6   /home/chd3beplive/chd3-chd2/unload.sh

# scripts to expire Empirix test accounts document records, so that weeding will delete them
#LIVE10 0,4,8,12,16,20 * * * /home/chd3beplive/chd3backend/expireEmpirixDocs.sh

# scripts to expire Empirix test accounts order records, so that weeding will delete them
#LIVE20 0,4,8,12,16,20 * * * /home/chd3beplive/chd3backend/expireEmpirixOrders.sh

#LIVE# script that mails weekly monitor totals to MIU
#LIVE# turned off 27/04/2020
#LIVE#25 6 * * 1 /home/chd3beplive/chd3backend/getMonitorTotals.sh

#INC0294077
#LIVE0 8,9,10,11,12,13,14,15,16,17,18 * * 1-5 /home/chd3beplive/chd3backend/getCHDFicheOrders.sh
# special one at end of day to catch any after 6pm
#LIVE59 23 * * 1-5 /home/chd3beplive/chd3backend/getCHDFicheOrders.sh
#LIVE#sr20 15 * * 1-5 /home/chd3beplive/chd3backend/getCHDFicheOrders.sh
#LIVE#sr40 15 * * 1-5 /home/chd3beplive/chd3backend/getCHDFicheOrders.sh
#LIVE59 23 * * *   /home/chd3beplive/chd3backend/getFHDOCorders.sh
###INC0042846 - request to change run time
#LIVE00 11 * * 1-5 /home/chd3beplive/chd3backend/getTotalFicheOrders.sh
#LIVE12 11 * * 1-5 /home/chd3beplive/chd3backend/getTotalFicheOrders.sh
#LIVE#30 10 * * 1-5 /home/chd3beplive/chd3backend/getBULKFicheOrders.sh # Changed as requested by GHI
#LIVE05 11 * * 1-5 /home/chd3beplive/chd3backend/getBULKFicheOrders.sh # Changed as requested by GHI
#LIVE#0 6 * * 0,3 /home/chd3beplive/chd3backend/secretsquirrel.sh
#LIVE*/5 * * * * /home/chd3beplive/chd3backend/ORAerror.sh
#LIVE# Job to clear down the robot account download area on a daily basis.
#LIVE01 0,4,8,12,16,20 * * * find /mnt/ha/image/79/15/57 -type f -mtime +1 -exec rm -f {} \;
#LIVE30 23 * * * /home/chd3beplive/chd3backend/chd-cleanup.sh
#LIVE25 21 * * * /home/chd3beplive/chd3backend/chd-cleanup.sh
# end

#STAGE## DO NOT EDIT THIS FILE - edit the master and reinstall.
#STAGE## (/tmp/crontab.1551 installed on Thu Nov  2 09:20:32 2006)
#STAGE## (Cron version -- $Id: crontab.c,v 2.13 1994/01/17 03:20:37 vixie Exp $)
#STAGE## min hour day month weekday
#STAGE#
#STAGE## Partition orders into product groups every minute
#STAGE#
#STAGE*/1 7-23 * * *     /home/chd/chd3backend/partition.sh
#STAGE#
#STAGE## Generate reports mon-sat 7am->midnight every minute
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/reports.sh
#STAGE#
#STAGE## Generate images mon-sat 7am->midnight
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/images.sh
#STAGE#
#STAGE## Generate packages mon-sat 7am->midnight
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/packages.sh
#STAGE#
#STAGE## Generate scud mon-sat 7am->midnight
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/scud.sh
#STAGE#
#STAGE## Generate fiche mon-sat 7am->midnight
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/fiche.sh
#STAGE#
#STAGE## Generate invoices mon-sat 7am->midnight (used for Certified Copies etc)
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/invoice.sh
#STAGE#
#STAGE## Generate jobsheets mon-sat 7am->midnight (used for Certified Copies etc)
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/jobsheet.sh
#STAGE#
#STAGE## Generate (charge) monitor orders mon-sat 7am->midnight
#STAGE##
#STAGE*/1 7-23 * * *  /home/chd/chd3backend/monitor.sh
#STAGE#
#STAGE## Do monitor Matching process mon-sat every 10 mins
#STAGE## (This should only pick up matches once - but for testing purposes......)
#STAGE##
#STAGE*/10 7-23 * * *  /home/chd/chd3backend/monitorMatch.sh
#STAGE#
#STAGE## Dispatch Faxes mon-sat 7am->midnight
#STAGE##
#STAGE##*/1 7-23 * * *  /home/chd/chd3backend/fax.sh
#STAGE#
#STAGE## Scan for and record Fax delivery status to CH report dir and to Database
#STAGE##
#STAGE##*/5 7-23 * * *  /home/chd/chd3backend/faxStatus.sh
#STAGE#
#STAGE## Scan for internal-delivery products (Currently Cert Copies etc)
#STAGE##
#STAGE#MARK*/1 7-23 * * *  /home/chd/chd3backend/internal.sh
#STAGE#
#STAGE## WEEDING
#STAGE##
#STAGE##*/5 7-23 * * *  /home/chd/chd3backend/weedall.sh

# end

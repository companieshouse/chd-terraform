# Partition orders into product groups every minute
*/1 7-23 * * * /home/chd/chd3backend/partition.sh

# Generate reports mon-sat 7am->midnight every minute
*/1 7-23 * * * /home/chd/chd3backend/reports.sh

# Generate images mon-sat 7am->midnight
*/1 7-23 * * * /home/chd/chd3backend/images.sh

# Generate packages mon-sat 7am->midnight
*/1 7-23 * * * /home/chd/chd3backend/packages.sh

# Generate scud mon-sat 7am->midnight
*/1 7-23 * * * /home/chd/chd3backend/scud.sh

# Generate fiche mon-sat 7am->midnight
*/1 7-23 * * * /home/chd/chd3backend/fiche.sh

# Generate invoices mon-sat 7am->midnight (used for Certified Copies etc)
*/1 7-23 * * * /home/chd/chd3backend/invoice.sh

# Generate jobsheets mon-sat 7am->midnight (used for Certified Copies etc)
*/1 7-23 * * * /home/chd/chd3backend/jobsheet.sh

# Generate (charge) monitor orders mon-sat 7am->midnight
*/1 7-23 * * * /home/chd/chd3backend/monitor.sh

# Do monitor Matching process mon-sat every 10 mins
# (This should only pick up matches once - but for testing purposes......)
*/10 7-23 * * * /home/chd/chd3backend/monitorMatch.sh

# Dispatch Faxes mon-sat 7am->midnight
*/1 7-23 * * * /home/chd/chd3backend/fax.sh

# Scan for and record Fax delivery status to CH report dir and to Database
*/5 7-23 * * * /home/chd/chd3backend/faxStatus.sh

# Scan for internal-delivery products (Currently Cert Copies etc)
*/1 7-23 * * * /home/chd/chd3backend/internal.sh

# WEEDING
*/5 7-23 * * * /home/chd/chd3backend/weedall.sh chd3

#!/usr/bin/perl 
# $Revision: 8.13 $
# $Id: getReport.pl,v 8.13 2016/03/28 20:49:39 rat Exp rat $
# $Author: rat $
# $Date: 2016/03/28 20:49:39 $
# $Log: getReport.pl,v $
# Revision 8.13  2016/03/28 20:49:39  rat
# Switch to PROD version (Mac) and added notes making this part clearer.
#
# Revision 8.12  2016/03/25 16:48:49  rat
# Had to create extra match for WC7830 for some reason.
#
# Revision 8.11  2016/03/25 16:29:07  rat
# Checking on weird errors caused by WC7525.  It is simply caused by the codes NOT
# being in the DepartmentCodes list.  I added and older, more complete copy and 
# got it down to just there:
# (1) XSAcolorreportWC7525Jul232015.csv.txt: DIGEST IS 5d6e3bd8b82a1b28a558ff9914f29c22
# (1) Processing a yet another color report: XSAcolorreportWC7525Jul232015.csv.txt
# 0ID err: Inappropriate ioctl for device
# !$ecivreS err: Inappropriate ioctl for device
# 0 err: Inappropriate ioctl for device
# 04023 err: Inappropriate ioctl for device
# 04311 err: Inappropriate ioctl for device
# 04328 err: Inappropriate ioctl for device
# 04508 err: Inappropriate ioctl for device
# 04558 err: Inappropriate ioctl for device
# 04611 err: Inappropriate ioctl for device
# 04928 err: Inappropriate ioctl for device
# 04951 err: Inappropriate ioctl for device
# 04957 err: Inappropriate ioctl for device
# 07002 err: Inappropriate ioctl for device
# 07427 err: Inappropriate ioctl for device
# 22222 err: Inappropriate ioctl for device
# 34769 err: Inappropriate ioctl for device
# 35097 err: Inappropriate ioctl for device
# 35194 err: Inappropriate ioctl for device
# 36804 err: Inappropriate ioctl for device
# 666666 err: Inappropriate ioctl for device
# 70111 err: Inappropriate ioctl for device
# 70257 err: Inappropriate ioctl for device
# admin err: Inappropriate ioctl for device
#
# To fix, make entries for all of these in DepartmentCodes file.
#
# Revision 8.10  2016/03/25 16:13:35  rat
# Appears to be working.  Next will remove unneeded subroutines.
#
# Revision 8.9  2016/03/25 16:00:46  rat
# Fixed previous issue: The OR statement in WC7830 MD5SUM broke code.
# Now, it appears the new COB and NURS WC7830 examples are different.
#
# Revision 8.8  2016/03/25 15:45:00  rat
# Major issues with MD5SUM matching.
# PROBLEMS:
# 5735report.csv.txt 			WC7830:
# 5955report.csv.txt 			WC7830:
# XSAreportWC5945Aug272015.csv.txt	WC7830:
#
# XSAcolorreportCOB2Feb262016.csv.txt	WC7830:
# XSAcolorreportNurSFeb262016.csv.txt	WC7830:
#
# XSAcolorreportWC7830Aug262015.csv.txt	WC7830:
# XSAreportWC3655Sep12015.csv.txt		WC3655:
# XSAreportWC5735Aug112015.csv.txt	NoFax:
# XSAcolorreportWC7525Jul232015.csv.txt	yetAnother:
# XSAcolorQubereport9302Aug312015.csv.txt ColorQube:
#
# (1) 5735report.csv.txt: DIGEST IS 2c0d844465fd1fe6a236a60751f5d408
# (1) Processing a WC7830 report: 5735report.csv.txt
# (2) 5955report.csv.txt: DIGEST IS 7a58a2c77a8359ab0e68e3b1da388c51
# (2) Processing a WC7830 report: 5955report.csv.txt
# (3) XSAcolorreportCOB2Feb262016.csv.txt: DIGEST IS 0163f09f7dbe1f58c62c8f420e4708c5
# (3) Processing a WC7830 report: XSAcolorreportCOB2Feb262016.csv.txt
# (4) XSAcolorreportNurSFeb262016.csv.txt: DIGEST IS 0163f09f7dbe1f58c62c8f420e4708c5
# (4) Processing a WC7830 report: XSAcolorreportNurSFeb262016.csv.txt
# (5) XSAcolorreportWC7830Aug262015.csv.txt: DIGEST IS d74586bd1f4e3ea90bf32b0c9710abac
# (5) Processing a WC7830 report: XSAcolorreportWC7830Aug262015.csv.txt
# (6) XSAreportWC5945Aug272015.csv.txt: DIGEST IS beccbb8df37ad03ce7d17ee9a4ad92b5
# (6) Processing a WC7830 report: XSAreportWC5945Aug272015.csv.txt
#
# Revision 8.7  2016/03/25 14:50:26  rat
# Catching up minor cosmetic changes.  Mostly cleaning out old notes
# and adding extra print-to-screen messages to make troubleshooting
# easier.
#
# Revision 8.6  2016/03/19 22:31:56  rat
# Mostly done but WC7830 is a problem.
#
# Revision 8.5  2016/03/19 21:35:15  rat
# Changed NoFax (WC5900's - except 5945/55) to new reporting.
#
# Revision 8.4  2016/03/19 21:22:49  rat
# Changed ColorQube to new reporting.
#
# Revision 8.3  2016/03/19 21:13:57  rat
# Xerox 5955 reporting changed.  Tested ok.
#
# Revision 8.2  2016/03/19 20:39:22  rat
# Cleaned up.  Made swapping from test to prod easier (all in one place).
# Added counter and reporting to subroutines to see which ones were used.
# Fixed weird issue with MD5sum on WC7125 report (I think).  Answers to
# both checksums now.  Obsolete anyway (I think).
#
# Revision 8.1  2016/03/18 20:48:37  rat
# Major revision.  Removing half of the old printters and completely changing the report.
#
# Revision 7.12  2016/01/08 16:30:09  rat
# Final version pulled from Greg C's mac.
#
# Revision 7.11  2015/10/15 19:56:36  rat
# Program count was working fine - had a wrong file in the directory.
# While troubleshooting this - Added counts to the lines processed.
# Leaving it in as the reporting is clearer now anyways.
#
# Revision 7.10  2015/10/15 18:56:08  rat
# Added a 2nd WC5945 but called it WC5955 as both of thr newer(?) WC5945 had identical md5sums.
# BUG(?) It says it processed 11 of 12.  I think I broke the counter somewhere.  Need to fix.
#
# Revision 7.9  2015/10/14 16:58:24  rat
# Trial run failed.  Switched back to test mode.  Changed Processing line to report file name.
#
# Revision 7.8  2015/10/13 21:07:50  rat
# Missed the open(OUT,">myxrxrpt.csv") line.  Swapped it to work on Mac.
#
# Revision 7.7  2015/10/13 20:57:58  rat
# Swapped the $input, $err, $reports and @list lines to work on Greg's Mac.
#
# Revision 7.6  2015/10/02 21:25:44  rat
# Added WC7125, WC5945 and WC7830.  Tested ok.
# Needs .csv ending changed to .csv.txt for Mac.
# Needs location of Copier reports changed for Greg C.'s Mac.
#
# Revision 7.5  2015/10/02 15:38:55  rat
# Cleaned up mistakes in ColorQube when WC3655 didn't work.  The print line (and 
# variable names) must stay EXACTLY the same.  These are the values checked by
# the PrintNoZeros subroutine.
#
# It's really pretty simple. Make sure you have corresponding values for $Name,$billcode,$ColorCopyUsage,$BWCopyUsage,$ColorPrintUsage,$BWPrintUsage,$NetworkImagesSentUsage,$EfaxReceiveUsage,$MachineSerialNumber.  Set to zero colums that do not exist.  Nothing else matters.
#
# Revision 7.4  2015/10/01 15:23:12  rat
# Corrected field names and values per conversation with Greg C. for ColorQube reporting sub.
#
# Revision 7.3  2015/09/30 21:21:00  rat
# Added ColorQube subroutine and broke the script.
#
# (7.2.1 not in revision control)
# Revision 7.2.1  2014/05/08 deh
# Added logic to process New Qube report
#
# Revision 7.2  2011/10/12 20:48:18  rat
# Added a header to the columns per Greg C.
#
# Revision 7.1  2011/10/12 20:07:33  rat
# Added subroutine to discard lines without billable data and also discard the report header.  Hmmm... maybe should've left the first one in.
#
# Revision 6.1  2011/10/02 18:38:42  rat
# Should've made last version 6.  The one with the md5sum.  This one has lots of
# counting lines, counting repoerts.  It has a new broken out (not STDOUT) error
# report.  Also added more infor about the ID errors - where did they come from,
# etc.?
#
# Also, after some confusion with my awk adding of the line counts, added a tracker
# to the number of lines processed.  And, found it was NOT processing a filer and
# NOT telling me (because it was not a *csv.txt).  So, I added a check on the number
# of files in the directory no matter what they were labeled (in case files get labeled
# incorrectly (no!!)) so user can see whether all files in dir were processed.
#
# Revision 5.7  2011/09/30 21:38:46  rat
# Completely threw out original logic to check for report type.  It was file name based
# and the file names were prone to human error.  Used md5sum on the headers and found
# there were 5 different types of reports.  Until then, we were not 100% certain how
# many different types there were.  This way, if a new type of printer comes into play,
# it will alert you and not process it.
#
# Revision 5.6  2011/09/30 20:10:45  rat
# Working on several bugs.  Logic for checking to see if report is non-fax halts
# and you have to hit enter to continue.  Also, reading the first line somehow
# is not grabbing the headers and so the logic doesn't work.
#
# Revision 5.5  2011/09/30 13:38:42  rat
# Added check for BW non-faxing
#
# Revision 5.4  2011/09/21 19:48:51  rat
# Removed test code.  Added line feeds and extra info
# Added print statement to specify where it expects to read the files from.
# Added ending statement to tell user where final report is.
#
# Revision 5.3  2011/09/20 20:17:26  rat
# Working except Color Qube subroutine.  Concatenating number with string
# does not seem to work with the hash lookup.
#
# Revision 5.2  2011/09/11 16:34:19  rat
# Checking in first draft of version 5.
#
# Revision 5.1  2011/09/11 16:17:02  rat
# Created subroutines to handle each of the 3 report types.
# Need to add logic to sift off to the right subroutine.
#
# Revision 4.1  2011/08/09 21:36:32  rat
# Changed to process directory.  Still a few bugs but pretty close.
#
# Revision 3.1  2011/08/09 20:53:59  rat
# Works! Just need to process a directory and it should be prettty close.

use Digest::MD5 qw(md5 md5_hex md5_base64);

# To switch between Mac/Linux, swap these 5 lines
##### Linux uses these 5 lines below
$input = "/home/rat/workspace/XeroxAgain/DepartmentCodes.csv";
$err = "/home/rat/workspace/XeroxAgain/xrxerr.log";
$log = "/home/rat/workspace/XeroxAgain/xrxlog.log";
$reports = "/home/rat/workspace/XeroxAgain/CopierDownloads";
$out = "/home/rat/workspace/XeroxAgain/myxrxrpt.csv";
##### Mac uses these 5 lines below
# $input = "DepartmentCodes.csv";
# $err = "xrxerr.log";
# $log = "xrxlog.log";
# $reports = "/Users/gcarlisle/Desktop/CopierDownloads";
# $out = "myxrxrpt.csv";

open(OUT,">$out") or die "Cannot open myxrxrpt.csv: $!\n";
$count = 0;	# report count
$lnproc = 0;	# lines processed
$WC5955_no = 0; # Count which subroutines called and how many.
$WC7125_no = 0; # Same comment to $NoFax_no
$WC5945_no = 0;
$WC7830_no = 0;
$WC3655_no = 0;
$ColorQube_no = 0;
$newQube_no = 0;
$Qube_no = 0;
$Color_no = 0;
$yetAnother_no = 0;
$Regular_no = 0;
$NoFax_no = 0;
$rejected = 0;

$header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
print OUT $header;
%hashcodes=();

print "Running getReports.pl... reading in all *.csv.txt files from $reports\n\n";
# Stuff DepartmentCodes.csv into hash. e.g.
# "42154","Panhellinic Council",84002,05110,802
open(IN,"<$input") or die "Can't open $input: $!\n";
open(ERR,">$err") or die "Can't open $err: $!\n";
open(LOG,">$log") or die "Cannot open $log: $!\n";
while(<IN>){
	($digit5,$longname,$bannerfund,$org,$notsupposed2b) = split(/,/);
	$bill2 = "$bannerfund" . "-" . "$org";
	$digit5 =~ s/\"//g,$digit5;
	$hashcodes{$digit5} = $bill2;
}

# Check directory for mislabeled reports
# 

opendir(DIR, $reports);
LINE: while($FILE = readdir(DIR)) {
	next LINE if($FILE =~ /^\.\.?/);
	## check to see if it is a directory
	if(-d "$FILE"){
		$directory_count++;
	} else {
		print "$FILE\n";
		$file_count++;
	}
}
print "\n";
closedir(DIR);

chdir("$reports") or die "Cannot change to dir $reports: $!\n";

@list = <*.csv.txt>;	# Publishing's Mac insists on adding a .txt to the end
foreach $xreport (@list) {
	# code to check to see which subroutine is needed

	$count++;
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        $line = <XRPT>;
        #$digest = md5($line); # RAT - remove
        $digest = md5_hex($line);
	chomp($digest);
        close(XRPT);
	# reset $line to make sure the MD5sum doesn't get reused
	$line="";

        print "($count) $xreport: DIGEST IS $digest\n";
	# MD5SUM check
	if ($digest =~ m/2874c3aa4afb04928c4e4bff4bfcb360/) {
		&Regular;
	} elsif ($digest =~ m/5d6e3bd8b82a1b28a558ff9914f29c22/) {
		&yetAnother;
	} elsif ($digest =~ m/6f53b3213bd3a36a27413b74e37a5e68/) {
		&Qube;
	} elsif ($digest =~ m/6f9b6f013a56e15a86c6af82113d5d72/) {
		&NoFax;
	} elsif ($digest =~ m/f76f0325de4d0abbbbd2dc920f3c8ebe/) {
		&Color;
	} elsif ($digest =~ m/900c3becc0f7fb3521f1c6797074d1b6/) {
		&newQube;
	} elsif ($digest =~ m/ff5a5b8bd17a9182be7862b5bffc9a7b/) {
		&ColorQube;
	} elsif ($digest =~ m/f312c9fc5a67f2ef88b9f77d00e1399d/) {
		&WC3655;
	} elsif ($digest =~ m/d74586bd1f4e3ea90bf32b0c9710abac/) {
		&WC7830;
	} elsif ($digest =~ m/2c0d844465fd1fe6a236a60751f5d408/) {
		&NoFax;
	} elsif ($digest =~ m/beccbb8df37ad03ce7d17ee9a4ad92b5/) {
		&WC5945;
	} elsif ($digest =~ m/805b6acc03d4cc9cebddcc0a72970624/) {
		&WC7125;
	} elsif ($digest =~ m/7a58a2c77a8359ab0e68e3b1da388c51/) {
		&WC5955;
	} elsif ($digest =~ m/0163f09f7dbe1f58c62c8f420e4708c5/) {
		&WC7830;
	} else {
		++$rejected;
		print ERR "**WARNING: $xreport appears to be a new report type and was not processed. ($count)\n";
		print "**WARNING: $xreport appears to be a new report type and was not processed. ($count)\n";
	}
}

print "-------------------------------------------\n";
print "Processed $lnproc lines of data from $count files.\n";
$count = $count - $rejected;
print "Processed $count *.csv.txt files from the $file_count files in $reports.\n[NO OTHER FILES WERE PROCESSED]\n";
print "Output combined into report myxrxrpt.csv.\n";
print "Error published in $err.\n";
&PrintSubRoutinesUsed;
print "Types of copiers report in $log.\n";
close(OUT);
close(LOG);
	
#=================[Subroutines and Notes]======================#
sub WC5955() {
	++$WC5955_no;
        print "($count) Processing a WC5955 report: $xreport\n";
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        while(<XRPT>){
        $lnproc++;
	#ae0d99d04aed13c7a9c07987299b9db9 - on Mac
	#Account Name,Account ID,Account Type,Counter: Total Black Copy and Print Impressions,Limit: Black Copy Limit,Limit: Black Copy Used,Limit: Black Copy Remaining,Counter: Total Black Copy Impressions,Sub-Counter: Black Large Copy Impressions,Limit: Black Print Limit,Limit: Black Print Used,Limit: Black Print Remaining,Counter: Total Black Print Impressions,Sub-Counter: Black Large Print Impressions,Last Reset,Machine Serial Number,Report Date,Report Time
	#7a58a2c77a8359ab0e68e3b1da388c51 - on Linux
	#Account Name,Account ID,Account Type,Counter: Total Black Copy and Print Impressions,Limit: Black Copy Limit,Limit: Black Copy Used,Limit: Black Copy Remaining,Counter: Total Black Copy Impressions,Sub-Counter: Black Large Copy Impressions,Limit: Black Print Limit,Limit: Black Print Used,Limit: Black Print Remaining,Counter: Total Black Print Impressions,Sub-Counter: Black Large Print Impressions,Last Reset,Machine Serial Number,Report Date,Report Time
        ($Name,$ID,$AccountType,$BWCopyUsage,$BCLimit,$BCLimitUsed,$LimitBCRemain,$BCImp,$BCLargeImp,$LimitBP,$LimitBPused,$LimitBPremain,$BWPrintUsage,$SubBPLargeImp,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
        # This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
                #print "$ID\t";
        } elsif ($length > 5) {
                print ERR "WC5955/$xreport: ID $ID not used. Code > 5 digits.\n";
        }
        $billcode = ($hashcodes{$ID});

        $ColorCopyUsage = 0;                   #Not used on this device

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
		# $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
        }
        }
        close(XRPT);
}

sub WC7125() {
	++$WC7125_no;
        print "($count) Processing a WC7125 report: $xreport\n";
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        while(<XRPT>){
        $lnproc++;
	next unless /^Name/;
        #805b6acc03d4cc9cebddcc0a72970624
        #Serial Number,XDC388144
        #Report Date,09/01/2015
        #Report Time,09:00:43
        #
        #Name,ID,Account Type,Color Print Limit,Color Print Usage,Color Print Remaining,Black & White Print Limit,Black & White Print Usage,Black & White Print Remaining,Color Copy Limit,Color Copy Usage,Color Copy Remaining,Black & White Copy Limit,Black & White Copy Usage,Black & White Copy Remaining,Color Scan Limit,Color Scan Usage,Color Scan Remaining,Black & White Scan Limit,Black & White Scan Usage,Black & White Scan Remaining,Fax Limit,Fax Usage,Fax Remaining,Internet Fax Limit,Internet Fax Usage,Internet Fax Remaining,Last Reset
        ($Name,$ID,$AccountType,$CPLimit,$ColorPrintUsage,$CPRemain,$LimitBP,$BWPrintUsage,$Bpremain,$CCLimit,$ColorCopyUsage,$Ccremain,$BCLimit,$BWCopyUsage,$Bcremain,$ColorScanLimit,$ColorScanUsed,$ColorScanRemain,$BwscanLimit,$BwscanUse,$BwscanRemain,$FaxLimit,$FaxUse,$FaxRemain,$IntFaxLimit,$IntFaxUse,$IntFaxRemain,$LastRest) = split(/,/);
        # This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
                #print "$ID\t";
        } elsif ($length > 5) {
                print ERR "WC7125/$xreport: ID $ID not used. Code > 5 digits.\n";
        }
        $billcode = ($hashcodes{$ID});

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
        }
        }
        close(XRPT);
}


sub WC5945() {
	++$WC5945_no;
        print "($count) Processing a WC5945 report: $xreport\n";
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        while(<XRPT>){
        $lnproc++;
        #beccbb8df37ad03ce7d17ee9a4ad92b5
        #Account Name,Account ID,Account Type,Counter: Total Black Copy and Print Impressions,Limit: Black Copy Limit,Limit: Black Copy Used,Limit: Black Copy Remaining,Counter: Total Black Copy Impressions,Sub-Counter: Black Large Copy Impressions,Limit: Black Print Limit,Limit: Black Print Used,Limit: Black Print Remaining,Counter: Total Black Print Impressions,Sub-Counter: Black Large Print Impressions,Limit: Network Images Sent Limit,Limit: Network Images Sent Used,Limit: Network Images Sent Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
        ($Name,$ID,$AccountType,$BWCopyUsage,$BCLimit,$BCLimitUsed,$LimitBCRemain,$BCImp,$BCLargeImp,$LimitBP,$LimitBPused,$LimitBPremain,$BWPrintUsage,$SubBPLargeImp,$LimitNetworkSent,$NetworkImagesSentUsage,$LimitNetworkSentRemain,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
        # This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
                #print "$ID\t";
        } elsif ($length > 5) {
                print ERR "WC5945/$xreport: ID $ID not used. Code > 5 digits.\n";
        }
        $billcode = ($hashcodes{$ID});

        $ColorCopyUsage = 0;                   #Not used on this device

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
        }
        }
        close(XRPT);
}


sub WC7830() {
	++$WC7830_no;
        print "($count) Processing a WC7830 report: $xreport\n";
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        while(<XRPT>){
        $lnproc++;
        #d74586bd1f4e3ea90bf32b0c9710abac
        #A Account Name,
        #B Account ID,
        #C Account Type,
        #D Counter: Total Black Copy and Print Impressions,
        #E Counter: Total Color Copy and Print Impressions,
        #F Limit: Color Copy Limit,
        #G Limit: Color Copy Used,
        #H Limit: Color Copy Remaining,
        #I Counter: Total Color Copy Impressions,
        #J Sub-Counter: Color Large Copy Impressions,
        #K Limit: Black Copy Limit,
        #L Limit: Black Copy Used,
        #M Limit: Black Copy Remaining,
        #N Counter: Total Black Copy Impressions,
        #O Sub-Counter: Black Large Copy Impressions,
        #P Limit: Color Print Limit,
        #Q Limit: Color Print Used,
        #R Limit: Color Print Remaining,
        #S Counter: Total Color Print Impressions,
        #T Sub-Counter: Color Large Print Impressions,
        #U Limit: Black Print Limit,
        #V Limit: Black Print Used,
        #W Limit: Black Print Remaining,
        #X Counter: Total Black Print Impressions,
        #Y Sub-Counter: Black Large Print Impressions,
        #Z Last Reset,
        #AA Machine Serial Number,
        #BB Report Date,
        #CC Report Time
        ($Name,$ID,$AccountType,$BWCopyUsage,$ColorPrintUsage,$CCLimit,$CCLimitUsed,$CCLimitRemain,$ColorCopyUsage,$SubCCLargeImp,$BCLimit,$BCLimitUsed,$LimitBCRemain,$BCImp,$BCLargeImp,$CPLimit,$CPLimitUsed,$CPRemain,$TotalCPImp,$SubCPLargeImp,$LimitBP,$LimitBPused,$LimitBPremain,$BWPrintUsage,$SubBPLargeImp,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
        # This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
                #print "$ID\t";
        } elsif ($length > 5) {
                print ERR "WC7830/$xreport: ID $ID not used. Code > 5 digits.\n";
        }
        $billcode = ($hashcodes{$ID});

        $NetworkImagesSentUsage = 0;            #Not used on this device
        $EfaxReceiveUsage = 0;                  #Not used on this device

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
        }
        }
        close(XRPT);
}

sub WC3655() {
	++$WC3655_no;
        print "($count) Processing a WC3655 report: $xreport\n";
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        while(<XRPT>){
        $lnproc++;
#      DIGEST IS f312c9fc5a67f2ef88b9f77d00e1399d
#**WARNING: XSAreportWC3655Sep12015.csv appears to be a new report type and was not processed.
#Account Name,Account ID,Account Type,Counter: Total Black Copy and Print Impressions,Limit: Black Copy Limit,Limit: Black Copy Used,Limit: Black Copy Remaining,Counter: Total Black Copy Impressions,Limit: Black Print Limit,Limit: Black Print Used,Limit: Black Print Remaining,Counter: Total Black Print Impressions,Last Reset,Machine Serial Number,Report Date,Report Time

        ($Name,$ID,$AccountType,$BWCopyUsage,$LimitBC,$LimitBCused,$LimitBCremain,$CounteBCImp,$LimitBP,$LimitBPused,$LimitBPremain,$CounterBPimp,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);

        # This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
                #print "$ID\t";
        } elsif ($length > 5) {
                print ERR "WC3655/$xreport: ID $ID not used. Code > 5 digits.\n";
        }
        $billcode = ($hashcodes{$ID});

        # my best guess as to these values
	# No color - black & white only
	# No fax
        $ColorCopyUsage = 0;                   #Not used on this device

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
        }
        }
        close(XRPT);
}

sub ColorQube() {
	++$ColorQube_no;
        print "($count) Processing a ColorQube report (no fax): $xreport\n";
        open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
        while(<XRPT>){
        $lnproc++;
        #ff5a5b8bd17a9182be7862b5bffc9a7b
#Account Name,Account ID,Account Type,Counter: Total Black + Level 1 Copy and Print
#Impressions,Counter: Total Color Level 2 Copy and Print Impressions,Counter: Total Color
#Level 3 Copy and Print Impressions,Limit: Color Copy Limit (Levels 2 + 3),Limit: Color
#Copy Used (Levels 2 + 3),Limit: Color Copy Remaining (Levels 2 + 3),Counter: Color Level
#1 Copy Impressions,Counter: Color Level 2 Copy Impressions,Counter: Color Level 3 Copy
#Impressions,Counter: Total Color Copy Impressions (Levels 1 + 2 + 3),Sub-Counter: Color 
#Large Copy Impressions,Limit: Black + Level 1 Copy Limit,Limit: Black + Level 1 Copy
#Used,Limit: Black + Level 1 Copy Remaining,Sub-Counter: Black Copy Impressions,Sub
#Counter: Black Large Copy Impressions,Limit: Color Print Limit (Levels 2 + 3),Limit:
#Color Print Used (Levels 2 + 3),Limit: Color Print Remaining (Levels 2 + 3),Counter: 
#Color Level 1 Print Impressions,Counter: Color Level 2 Print Impressions,Counter: Color
#Level 3 Print Impressions,Counter: Total Color Print Impressions (Levels 1 + 2 + 3),Sub
#Counter: Color Large Print Impressions,Limit: Black + Level 1 Print Limit,Limit: Black +
#Level 1 Print Used,Limit: Black + Level 1 Print Remaining,Sub-Counter: Black Print
#Impressions,Sub-Counter: Black Large Print Impressions,Last Reset,Machine Serial
#Number,Report Date,Report Time
       
        ($Name,$ID,$AccountType,$BWCopyUsage,$CounterL2,$CounterL3,$CCLimit,$CCLimitUsed,$CCLimitRemaining,$CCLevel1,$CCLevel2,$CCLevel3,$TotalCC,$SubCountColorLarge,$BlackCopyLimit,$BlackCopyLimitUsed,$BlackCopyLimitRemaining,$SubCountBlackCopy,$SubCountBlackLarge,$ColorPrintLimit,$ColorPrintUsage,$ColorPrintRemaining,$CPLevel1,$CPLevel2,$CPLevel3,$CPTotal,$SubCountColorLargePrint,$BlackPrintL1,$BlackPrintL1Used,$BlackPrintL1Remaining,$SubCountBlackPrint,$SubCountBlackPrintLarge,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);

        # This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
        }
        $length = length($ID);
        if ( $length < 5 ) {
                $ID = "0" . $ID;
                #print "$ID\t";
        } elsif ($length > 5) {
                print ERR "ColorQube/$xreport: ID $ID not used. Code > 5 digits.\n";
        }
        $billcode = ($hashcodes{$ID});

	# This field is calculated thusly (I am told)
	$ColorCopyUsage = $CounterL2 + $CounterL3;

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
        }
        }
        close(XRPT);
}

sub newQube() {
	++$newQube_no;
	print "($count) Processing a newQube report: $xreport\n";
	open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
	while(<XRPT>){
	$lnproc++;
	#900c3becc0f7fb3521f1c6797074d1b6
	#Account Name,Account ID,Account Type,Counter: Total Black + Level 1 Copy and Print Impressions,Counter: Total Color Level 2 Copy and Print Impressions,Counter: Total Color Level 3 Copy and Print Impressions,Limit: Color Copy Limit (Levels 2 + 3),Limit: Color Copy Used (Levels 2 + 3),Limit: Color Copy Remaining (Levels 2 + 3),Counter: Color Level 1 Copy Impressions,Counter: Color Level 2 Copy Impressions,Counter: Color Level 3 Copy Impressions,Counter: Total Color Copy Impressions (Levels 1 + 2 + 3),Sub-Counter: Color Large Copy Impressions,Limit: Black + Level 1 Copy Limit,Limit: Black + Level 1 Copy Used,Limit: Black + Level 1 Copy Remaining,Sub-Counter: Black Copy Impressions,Sub-Counter: Black Large Copy Impressions,Limit: Color Print Limit (Levels 2 + 3),Limit: Color Print Used (Levels 2 + 3),Limit: Color Print Remaining (Levels 2 + 3),Counter: Color Level 1 Print Impressions,Counter: Color Level 2 Print Impressions,Counter: Color Level 3 Print Impressions,Counter: Total Color Print Impressions (Levels 1 + 2 + 3),Sub-Counter: Color Large Print Impressions,Limit: Black + Level 1 Print Limit,Limit: Black + Level 1 Print Used,Limit: Black + Level 1 Print Remaining,Sub-Counter: Black Print Impressions,Sub-Counter: Black Large Print Impressions,Limit: Network Images Sent Limit,Limit: Network Images Sent Used,Limit: Network Images Sent Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
	($Name,$ID,$AccountType,$BkPlusL1CpAndPr,$TotL2CpAndPr,$TotL3CpAndPr,$LimL2PlusL3,$L2PlusL3,$RemL2PlusL3,$CpL1,$CpL2,$CpL3,$ColorCopyUsage,$LgClCp,$LimCpBkPlusL1,$CpBkPlusL1,$RemCpBkPlusL1,$BWCopyUsage,$LgBkCp,$PrLimL2PlusL3,$PrL2PlusL3,$PrRemL2PlusL3,$PrL1,$PrL2,$PrL3,$ColorPrintUsage,$LgClPr,$LimBlPlusL1Pr,$PrBlPlusL1,$RemBlPlusL1Pr,$BWPrintUsage,$LgBlPr,$LimNtwkImgSent,$NetworkImagesSentUsage,$RemNtwkImgSent,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
	$EfaxReceiveUsage="0";
	# This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
	}
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
	}
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
		#print "$ID\t";
        } elsif ($length > 5) {
		print ERR "Qube/$xreport: ID $ID not used. Code > 5 digits.\n";
	}
	$billcode = ($hashcodes{$ID});

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
	}
	}
	close(XRPT);
}

sub Qube() {
	++$Qube_no;
	print "($count) Processing a Qube report: $xreport\n";
	open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
	while(<XRPT>){
	$lnproc++;
	#6f53b3213bd3a36a27413b74e37a5e68
	#Name,ID,Account Type,Color Copy Limit,Color Copy Usage,Color Copy Remaining,BW Copy Limit,BW Copy Usage,BW Copy Remaining,Color Print Limit,Color Print Usage,Color Print Remaining,BW Print Limit,BW Print Usage,BW Print Remaining,Network Images Sent Limit,Network Images Sent Usage,Network Image Sent Remaining,EFax Limit,EFax Usage,Efax Remaining,Efax Receive Limit,Efax Receive Usage,EFax Receive Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
	($Name,$ID,$AccountType,$ColorCopyLimit,$ColorCopyUsage,$ColorCopyRemaining,$BWCopyLimit,$BWCopyUsage,$BWCopyRemaining,$ColorPrintLimit,$ColorPrintUsage,$ColorPrintRemaining,$BWPrintLimit,$BWPrintUsage,$BWPrintRemaining,$NetworkImagesSentLimit,$NetworkImagesSentUsage,$NetworkImageSentRemaining,$EFaxLimit,$EFaxUsage,$EfaxRemaining,$EfaxReceiveLimit,$EfaxReceiveUsage,$EFaxReceiveRemaining,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTimeCustomerServiceEngineerAccount) = split(/,/);
	# This report has a lot of non-zero-padded codes. Codes need to be 5 digits.
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
	}
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
	}
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
		#print "$ID\t";
        } elsif ($length > 5) {
		print ERR "Qube/$xreport: ID $ID not used. Code > 5 digits.\n";
	}
	$billcode = ($hashcodes{$ID});

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
	}
	}
	close(XRPT);
}

sub Color() {
	++$Color_no;
	print "($count) Processing a color (non-fax) report: $xreport\n";
	open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
	while(<XRPT>){
	$lnproc++;
	#f76f0325de4d0abbbbd2dc920f3c8ebe
	#Name,ID,Account Type,Color Copy Limit,Color Copy Usage,Color Copy Remaining,BW Copy Limit,BW Copy Usage,BW Copy Remaining,Color Print Limit,Color Print Usage,Color Print Remaining,BW Print Limit,BW Print Usage,BW Print Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
	($Name,$ID,$AccountType,$ColorCopyLimit,$ColorCopyUsage,$ColorCopyRemaining,$BWCopyLimit,$BWCopyUsage,$BWCopyRemaining,$ColorPrintLimit,$ColorPrintUsage,$ColorPrintRemaining,$BWPrintLimit,$BWPrintUsage,$BWPrintRemaining,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
        } elsif ($length > 5) {
		print ERR "ColorNF/$xreport: ID $ID not used. Code > 5 digits.\n";
	}
	$billcode = ($hashcodes{$ID}) or warn "$ID err: $!\n";

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
	}
	}
	close(XRPT);
}

sub yetAnother() {
	# 7525
	++$yetAnother_no;
	print "($count) Processing a yet another color report: $xreport\n";
	open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
	while(<XRPT>){
	$lnproc++;
	#5d6e3bd8b82a1b28a558ff9914f29c22
	#Name,ID,Account Type,Color Copy Limit,Color Copy Usage,Color Copy Remaining,BW Copy Limit,BW Copy Usage,BW Copy Remaining,Color Print Limit,Color Print Usage,Color Print Remaining,BW Print Limit,BW Print Usage,BW Print Remaining,Network Images Sent Limit,Network Images Sent Usage,Network Image Sent Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
	($Name,$ID,$AccountType,$ColorCopyLimit,$ColorCopyUsage,$ColorCopyRemaining,$BWCopyLimit,$BWCopyUsage,$BWCopyRemaining,$ColorPrintLimit,$ColorPrintUsage,$ColorPrintRemaining,$BWPrintLimit,$BWPrintUsage,$BWPrintRemaining,$NetworkImagesSentLimit,$NetworkImagesSentUsage,$NetworkImageSentRemaining,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
        } elsif ($length > 5) {
		print ERR "Color/$xreport: ID $ID not used. Code > 5 digits.\n";
	}
	$billcode = ($hashcodes{$ID}) or warn "$ID err: $!\n";

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
	}
	}
	close(XRPT);
}

sub Regular() {
	++$Regular_no;
	print "($count)Processing a regular report: $xreport\n";
	open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
	while(<XRPT>){
	$lnproc++;
	#2874c3aa4afb04928c4e4bff4bfcb360
	#Name,ID,Account Type,BW Copy Limit,BW Copy Usage,BW Copy Remaining,BW Print Limit,BW Print Usage,BW Print Remaining,Network Images Sent Limit,Network Images Sent Usage,Network Image Sent Remaining,EFax Limit,EFax Usage,Efax Remaining,Efax Receive Limit,Efax Receive Usage,EFax Receive Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
	($Name,$ID,$AccountType,$BWCopyLimit,$BWCopyUsage,$BWCopyRemaining,$BWPrintLimit,$BWPrintUsage,$BWPrintRemaining,$NetworkImagesSentLimit,$NetworkImagesSentUsage,$NetworkImageSentRemaining,$EFaxLimit,$EFaxUsage,$EfaxRemaining,$EfaxReceiveLimit,$EfaxReceiveUsage,$EFaxReceiveRemaining,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
	$ColorCopyUsage="0";	# Doesn't exist on this system
	$ColorPrintUsage="0";	# Would've set to NA but need 
        $NetworkImagesSentUsage="0";   # check for zero later.
        $EfaxReceiveUsage="0";  
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
        } elsif ($length > 5) {
		print ERR "Regular/$xreport: ID $ID not used. Code > 5 digits.\n";
	}
	$billcode = ($hashcodes{$ID});

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
		print "$MachineSerialNumber\n";
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
	}
	}
	close(XRPT);
}

sub NoFax() {
	# This is the 5735 series printer
	++$NoFax_no;
	print "($count) Processing a regular report (no fax,5735): $xreport\n";
	open(XRPT,"<$xreport") or die "Cannot open $xreport: $!\n";
	while(<XRPT>){
	$lnproc++;
	#6f9b6f013a56e15a86c6af82113d5d72
	#Name,ID,Account Type,BW Copy Limit,BW Copy Usage,BW Copy Remaining,BW Print Limit,BW Print Usage,BW Print Remaining,Network Images Sent Limit,Network Images Sent Usage,Network Image Sent Remaining,Last Reset,Machine Serial Number,Report Date,Report Time
	($Name,$ID,$AccountType,$BWCopyLimit,$BWCopyUsage,$BWCopyRemaining,$BWPrintLimit,$BWPrintUsage,$BWPrintRemaining,$NetworkImagesSentLimit,$NetworkImagesSentUsage,$NetworkImageSentRemaining,$LastReset,$MachineSerialNumber,$ReportDate,$ReportTime) = split(/,/);
 	$ColorCopyUsage="0";		# These do not exist on this system
	$length = length($ID);
	if ( $length < 5 ) {
               	$ID = "0" . $ID;
        } elsif ($length > 5) {
		print ERR "5735-RegularNF/$xreport: ID $ID not used. Code > 5 digits.\n";
	}
	$billcode = ($hashcodes{$ID});

        unless (m/^Name,/) {
                &PrintNoZeros;
        }
        unless ($zeros<1) {
                # $header = "Name,Banner-Org,BW Copy Usage,Color Copy Usage,Machine Serial Number\n";
                print OUT "$Name,$billcode,$BWCopyUsage,$ColorCopyUsage,$MachineSerialNumber\n";
	}
	}
	close(XRPT);
}

sub PrintNoZeros {
# Find lines with no billable data and discard
        $zeros=0;
        if ($ColorCopyUsage >0) {$zeros++;}
        if ($BWCopyUsage >0) {$zeros++;}
        if ($ColorPrintUsage >0) {$zeros++;}
        if ($BWPrintUsage >0) {$zeros++;}
        if ($NetworkImagesSentUsage >0) {$zeros++;}
        if ($EfaxReceiveUsage >0) {$zeros++;}
        return $zeros;
}

sub PrintSubRoutinesUsed {
# Print a report on which subroutines are called and how many times.
print LOG "    WC5955: $WC5955_no\n";; 
print "    WC5955: $WC5955_no\n";; 
print LOG "    WC7125: $WC7125_no\n"; 
print "    WC7125: $WC7125_no\n"; 
print LOG "    WC5945: $WC5945_no\n";
print "    WC5945: $WC5945_no\n";
print LOG "    WC7830: $WC7830_no\n";
print "    WC7830: $WC7830_no\n";
print LOG "    WC3655: $WC3655_no\n";
print "    WC3655: $WC3655_no\n";
print LOG " ColorQube: $ColorQube_no\n";
print " ColorQube: $ColorQube_no\n";
print LOG "   newQube: $newQube_no\n";
print "   newQube: $newQube_no\n";
print LOG "   Qube_no: $Qube_no\n";
print "   Qube_no: $Qube_no\n";
print LOG "  Color_no: $Color_no\n";
print "  Color_no: $Color_no\n";
print LOG "yetAnother: $yetAnother_no\n";
print "yetAnother: $yetAnother_no\n";
print LOG "Regular_no: $Regular_no\n";
print "Regular_no: $Regular_no\n";
print LOG "     NoFax: $NoFax_no\n";
print "     NoFax: $NoFax_no\n";
}

end;

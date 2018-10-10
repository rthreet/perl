#!/usr/bin/perl 
# RAT program readLDIF2.pl: Son of LDIF
# July 6, 2009
# Creates all "reports" - email lists for mailing lists

use Net::LDAP::LDIF;

$student = "Student.rpt";
$student_no = 0;
open(STUDENT,">$student") or die "Can't open $student: $!\n";
$faculty = "Faculty.rpt";
$faculty_no = 0;
open(FACULTY,">$faculty") or die "Can't open $faculty: $!\n";
$employee = "Employee.rpt";
$employee_no = 0;
open(EMPLOYEE,">$employee") or die "Can't open $employee: $!\n";
$alumni = "Alumni.rpt";
$alumni_no = 0;
open(ALUMNI,">$alumni") or die "Can't open $alumni: $!\n";
$current = "Current.rpt";
$current_no = 0;
open(CURRENT,">$current") or die "Can't open $current: $!\n";

$ldif = Net::LDAP::LDIF->new( "/zpool1/ldifs/LDIF_Tue.ldif", "r", onerror => 'undef' ) or die "Can't open LDIF:$!\n";
while( not $ldif->eof ( ) ) {
   $entry = $ldif->read_entry ( );
   if ( $ldif->error ( ) ) {
     print "Error msg: ", $ldif->error ( ), "\n";
     print "Error lines:\n", $ldif->error_lines ( ), "\n";
   } 
   $uid = $entry->get_value("uid");
   $role = $entry->get_value("usiprimaryrole");
   $enrolled = $entry->get_value("usienrolled");
   if ($role =~ m/$look4/) {
	if ($role =~ m/Student/) {
		$student_no++;
		print STUDENT "$uid\@mail.usi.edu\n";
		if ($enrolled =~ m/true/) {
			$current_no++;
			print CURRENT "$uid\@mail.usi.edu\n";
		}
	} elsif ($role =~ m/Faculty/) {
		$faculty_no++;
		print FACULTY "$uid\@mail.usi.edu\n";
	} elsif ($role =~ m/Employee/) {
		$employee_no++;
		print EMPLOYEE "$uid\@mail.usi.edu\n";
	} elsif ($role =~ m/Alumni/) {
		$alumni_no++;
		print ALUMNI "$uid\@mail.usi.edu\n";
	}
   }
}
$ldif->done ( );

print "\nResults:\n========\nEmployees\t\t$employee_no\nFaculty\t\t\t$faculty_no\nAlumni\t\t\t$alumni_no\nStudents\t\t$student_no\nCurrently Enrolled\t$current_no\n\nEmail lists: Student.rpt, Current.rpt, Alumni.rpt, Employee.rpt, Faculty.rpt\n\n";

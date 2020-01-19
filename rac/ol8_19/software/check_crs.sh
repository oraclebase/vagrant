#!/bin/sh
#
# Version 1.0 - 4-5-2014  : Initial write
# Version 1.1 - 2-8-2014  : Implemented Line Break feature by checking location of first and forth parameter
#                           The following conditions are handled ( see <-- ... -> comments below )
#                           index($0,$1)  > 32 means we get a line with STATE details only and we have a line break there: 
#                             ora.acfs_dg1.acfs_vol1.acfs
#                                         ONLINE  OFFLINE      gract1                   admin unmounted /u01
#                                                                                 <---   /acfs/acfs-vol1,STAB  -->  
#                           index($0,$4) > 45 means we are missing server details for a Clustered resource 
#                             ora.asm
#                                    1        ONLINE  OFFLINE             <- server_is_missing_here ->              STABLE
# 
# Usage:  To display all resourcees     : $ ./crs 
#         To track a certain resource  :  $  watch ' crs | egrep "db|INST" '   <-- here <<db>> tracks all database resources 
#
$GRID_HOME/bin/crsctl stat res -t  \
  | awk -v t="$t" ' BEGIN { lres=0; cres= 0 } \
      $0 !~ "----" && $0 !~ "TARGET" && $0 !~ "Cluster Resources" && $0 !~ "Local Resources" && $0 !~ "State details" \
      { \
        if (NF == 1 && ( $0 ~ "^ora" || $0  ~ "^My")) { \
          rs=$0; \
          #printf("\nRS: %s \n", rs); \
        }  \
        else { \
          if ($1 ~ "^[0-9]") \
            { \
            # We found an Instance ID -> Global resource \
            if ( cres == 0 ) \
               { \
	       printf("\n*****  Cluster Resources: *****"); \
               printf("\n%-27s %-3s   %-12s %-12s %-15s %s","Resource NAME", "INST", "TARGET","STATE", "SERVER","STATE_DETAILS"); \
               printf("\n--------------------------- ----   ------------ ------------ --------------- -----------------------------------------"); \
               }  \
            cres++; \
            idx = index($0,$1);
                  # This is a tricky one - if are in APPEND mit idx should be > 60 
                  # The status messages like OFFLINE / ONLINE start at index 16 - so lets use 32 to be safe
            idx = index($0,$1); \
                  # Here we check wether wet some Node information or thie field is empty like instance or service down
            idx4 = index($0,$4); \
            # printf("\n Index4: %d ", idx4 );
	    if ( idx < 32   ) \
              { \
                # printf("Index: %d - Search:  %s --  %s " , idx, $1 , $0 );
                if ( idx4 < 45 ) \
                   printf ( "\n%-30s %-3s %-12s %-12s %-15s %s %s %s", rs, $1, $2, $3, $4, $5, $6,  $7 ); \
		else \
                   printf ( "\n%-30s %-3s %-12s %-12s %-15s %s %s %s", rs, $1, $2, $3, "-", $4, $5,  $6 ); \
               } \
            else { \
               line1=$0; \
               # remove leading spaces \
               gsub(/^[ \t]+/, "", line1);
               printf ( "%s", line1 ); 
               } \
            } \
          else { \
               # We found no Instance ID -> local resource 
            if ( lres == 0 ) \
               { \
	       printf("*****  Local Resources: *****"); \
               printf ("\n%-30s %-10s %-15s %-12s %-36s", "Rescource NAME", "TARGET", "STATE", "SERVER", "STATE_DETAILS");
               printf ("\n%-30s %-10s %-15s %-12s %-36s", "-------------------------", "----------", "----------", "------------", "------------------");
               } \
            lres++; \
                  # This is a tricky one - if are in APPEND mit idx should be > 60  
                  # The status messages like OFFLINE / ONLINE start at index 16 - so lets use 32 to be safe 
            idx = index($0,$1); \
                  # Here we check wether wet some Node information or thie field is empty like instance or service down
	    if ( idx < 32   ) \
              { \
                # printf("Index: %d - Search:  %s --  %s " , idx, $1 , $0 );
                printf ( "\n%-30s %-10s %-15s %-12s %s %s %s %s", rs, $1, $2, $3, $4, $5, $6,  $7 ); \
               } \
            else { \
               line1=$0; \
               # remove leading spaces \
               gsub(/^[ \t]+/, "", line1);
               printf ( "%s", line1 ); 
               } \
          } \
        } \
      }
  END { printf ( "\n\n" );  } \
  '
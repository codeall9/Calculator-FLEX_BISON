 #!/bin/bash
 flex cal.l
 bison -dtv cal.y
 g++ -g -o mm lex.yy.c cal.tab.c
 echo -e "##########################################"
./mm < tt
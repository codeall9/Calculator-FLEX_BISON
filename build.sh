 #!/bin/bash
 flex cal.l
 bison -dtv cal.y
 g++ -g -o out lex.yy.c cal.tab.c
 echo -e "##########################################"
./out < testfile
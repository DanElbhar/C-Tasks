#!/bin/bash

folder=$1

Program=$2

Agro=$3


cd $folder


make


if [ $? -gt 0 ] 
 then

 echo "Error"

 exit 0

else

echo "Succes  "

valgrind --leak-check=full -v ./$Program > memory.txt 2>&1

grep -q "no leaks are possible"  memory.txt

    if [ $? -eq 0 ] 
    then

        echo "leaks Sucess"
 
       rm memory.txt  

        valgrind --tool=helgrind $folder/$Program > Thread.txt 2>&1
   
     grep -q "ERROR SUMMARY: 0 errors" Thread.txt

            if [ $? -eq 0 ] 
            then
          
      echo "Thread Succes"
   
             rm Thread.txt 
 
               exit 3
   
             else 
 
                   echo "Thread  Failed"
 
                   rm Thread.txt
     
               exit 2

             fi

    else

        echo "Leak Failed"
  
      rm memory.txt

        valgrind --tool=helgrind $folder/$Program > Thread.txt 2>&1
   
     grep -q "ERROR SUMMARY: 0 errors" Thread.txt
 
           if [ $? -eq 0 ] 
 
           then
 
               echo "Thread  Succes"

                rm Thread.txt 
	
                exit 1

                else
    
                echo "Thread Failed"
     
               rm Thread.txt 

                    exit 0
  
          fi
  
  fi 

fi

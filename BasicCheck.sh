#!/bin/bash

folderName=$1

execute=$2

noneed=$3


cd $folderName


make


if [ $? -gt 0 ] 
 then

 echo "Error Compilation"

 exit 7

else

echo "Succes Compilation "

valgrind --tool=memcheck --leak-check=full --error-exitcode=3 ./$execute > memoryleaks.txt 2>&1

grep -q "no leaks are possible"  memoryleaks.txt

    if [ $? -eq 0 ] 
    then

        echo "Memory leaks Sucess"
 
       rm memoryleaks.txt  

        valgrind --tool=helgrind $folderName/$execute > Threadcheck.txt 2>&1
   
     grep -q "ERROR SUMMARY: 0 errors" Threadcheck.txt

            if [ $? -eq 0 ] 
            then
          
      echo "Thread Race Succes"
   
             rm Threadcheck.txt 
 
               exit 3
   
             else 
 
                   echo "Thread Race Failed"
 
                   rm Threadcheck.txt
     
               exit 2
             fi

    else

        echo "Memory Leak Failed"
  
      rm memoryleaks.txt

         valgrind --tool=helgrind  --error-exitcode=4 ./$execute > Threadcheck.txt 2>&1
   
     grep -q "ERROR SUMMARY: 0 errors" Threadcheck.txt
 
           if [ $? -eq 0 ] 
 
           then
 
               echo "Thread  Succes"

                rm Threadcheck.txt 
	
                exit 1	

                else
    
                echo "Thread Failed"
     
               rm Threadcheck.txt 

                    exit 0
  
          fi
  
  fi 

fi

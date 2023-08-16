#!/bin/bash
#Initial judement
if (($#!=0));then
    echo "waiting..."
else
    echo "Fucking idiot!Lack of params!"
    exit
fi

#Input parameter
Alloy_cnt=$1
Strain_st=$(printf "%d" `echo "scale=0;$2/0.0001" | bc`)
Strain_tml=$(printf "%d" `echo "scale=0;$3/0.0001" | bc`)
Strain_gap=$(printf "%d" `echo "scale=0;$4/0.0001" | bc`)
div=$(($Strain_tml-$Strain_st))

#Conditional judgement
if (($Alloy_cnt<1));then
    echo "Go to hell!The count of Alloy must be greater than one."
fi

if (($Strain_st<$Strain_tml))&&(($Strain_gap==0));then
    echo "What the fucking shit did you made?If start index is equal with the termination index,you must give a gap instead of zero."
fi 

if (($div<0));then
    echo "You stupid jerk!The start index is greater than the termination index of Strain_*!"
fi

#Checking and Calculating
for ((Strain_index=$Strain_st;Strain_index<=$Strain_tml;Strain_index=$(($Strain_index+$Strain_gap))))
do  
    idx=$Strain_index

    if (($((idx%1000))!=0));then
        if (($((idx%100))!=0));then
            if (($((idx%10))!=0));then
                idx=$(printf "%.4f" $(echo "scale=4;$idx/10000" | bc))
            else
                idx=$(printf "%.3f" $(echo "scale=3;$idx/10000" | bc))
            fi
        else
            idx=$(printf "%.2f" $(echo "scale=2;$idx/10000" | bc))
        fi   
    fi

    c_x=0
    c_y=0
    c_z=0
    for ((num=1;num<=$Alloy_cnt;num++))
	do
        Path=../Alloy_$num/ceshi/Strain_$idx/mcout10

        if [ -e $Path ];then

            Find_x=$(grep "Pol" $Path | awk '{print $2}')
            Find_y=$(grep "Pol" $Path | awk '{print $3}')
            Find_z=$(grep "Pol" $Path | awk '{print $4}')

            if [ ! -z "$Find_x" ]&&[ ! -z "$Find_y" ]&&[ ! -z "$Find_z" ];then

                Cal_cnt_x=$(echo "scale=15;$c_x+$Find_x" | bc)
                Cal_cnt_y=$(echo "scale=15; $c_y+$Find_y" | bc)
                Cal_cnt_z=$(echo "scale=15; $c_z+$Find_z" | bc)

                c_x=$Cal_cnt_x
		        c_y=$Cal_cnt_y
		        c_z=$Cal_cnt_z 

            else
            
                echo "What were you fucking doing!Not such content existed of file($PATH)!"
                exit

            fi
        else

            echo "Go eat some piece of shit!Not such file($Path) existed!"
            exit

        fi
 
    done

    Cal_avg_x=$(printf "%.15f" `echo "scale=15; $c_x/$Alloy_cnt" | bc`)
    Cal_avg_y=$(printf "%.15f" `echo "scale=15; $c_y/$Alloy_cnt" | bc`)
    Cal_avg_z=$(printf "%.15f" `echo "scale=15; $c_z/$Alloy_cnt" | bc`)
    
    avg_x=$Cal_avg_x
    avg_y=$Cal_avg_y
    avg_z=$Cal_avg_z

    printf "S_$idx:\t avg_x=$avg_x\t avg_y=$avg_y\t avg_z=$avg_z\n"

done

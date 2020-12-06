# Project: AES
## Run
> python script/grade.py

## VHDL code part
- How to start the project?
> The whole project is huge but we can divide it into many small parts. Although there are many rounds in the whole d/e process, we just need to implement some small entities like shift, add, sub, and so on. Later, I test each of them **respectively** and organize them in the top-level entity.

- How to write code for each entity?
> The C language code is a good resource for me to understand how data flows in each component. After totally understanding the C code, it will be a piece of cake to implement the VHDL one.

- How to deal with input and output?
> In this project, the order of the data is a complicated point. I process the data both in the script and VHDL code. To keep the integrity of the AES hardware part, I strictly follow the description in the material to organize the key and states inside the VHDL code. However, using the script to transfer raw data to bit input can make life easier.

## Test script part
- How to process raw data?
> Thankfully, python provides lots of useful methods for I/O. Also, it is easy to switch types of data and bases for int in python.

- How to test by ghdl?
> Usually, we use ghdl commands in the terminal or write them in one .sh file for convenience. Although we can use os.system() to do the same thing in python, I do think one .sh script is a better choice.

## Extra work
- Pipeline architecture, continuous processing of test data
> I add one register for each addroundkey component. Since addroundkey is in all rounds, the whole process is divided into #rounds stage pipeline.

- Adjustable number of input ports, can adapt to more scenarios
> I use generic length for input keys and if the length of the key is legal, it will generate proper hardware for each situation. However, the length can't be changed at runtime. I think it will waste areas for some unsused rounds.
 
- Dynamic encryption and decryption, encryption operation or decryption operation can be selected in running time
> There are one encryption and decryption in the top level entity, so it can select which mode it runs. 

- Complete comments, standard writing, my code can be used as a tutorial

## Potential imporvement
- The decryption and encryption use the same components but arrange them in a different order. Actually, we can add some muxes and just use one set to do two operations.

- The #registers for the expanded key can be cut off by a good controller.  

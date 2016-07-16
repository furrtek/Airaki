;Airaki! - FSE 2014
;Released under the GPL V3, see LICENSE.TXT

// Checksum generator
// Last mod: furrtek 21/02/2014
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
  char ch;
  FILE *romfile;
  int short checksum=0;   //16bits
  int size;
  
  if (argc != 2) {
         puts("Usage: checksumgen rom.gb\n");
    } else {
         romfile = fopen(argv[1],"r+b");
         if (!romfile) {
            write("Can't open %s\n",argv[1]);
            return 1;
         }
         fseek(romfile,0x150,SEEK_SET);
         for (size=0;size<32768-0x150;size++) {
             checksum += fgetc(romfile);
         }
         printf("Custom checksum: %X\n",checksum & 0xFFFF);
         fseek(romfile,0x4D,SEEK_SET);
         fwrite(&checksum,sizeof(int short),1,romfile);
         
         checksum=0;
         fseek(romfile,0,SEEK_SET);
         for (size=0;size<0x14E;size++) {
             checksum += fgetc(romfile);
         }
         fseek(romfile,0x150,SEEK_SET);
         for (size=0;size<32768-0x150;size++) {
             checksum += fgetc(romfile);
         }
         checksum = ((checksum & 0xFF) << 8) + ((checksum & 0xFF00) >> 8);
         printf("ROM Checksum: %X\n",checksum & 0xFFFF);
         fseek(romfile,0x14E,SEEK_SET);
         fwrite(&checksum,sizeof(int short),1,romfile);
         
         fclose(romfile);
  }
  return 0;
}

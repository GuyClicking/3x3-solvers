#include <stdio.h>

typedef struct {
	unsigned int co, eo, cp, ep;
} Cube;

typedef enum {
	WHITE, GREEN, RED, BLUE, ORANGE, YELLOW
} Sticker;

Cube stickersToCube(Sticker sticker_cube[54]) {
	Cube cube;
	return cube;
}

Cube parse_input(char *str) {
	Sticker sticker_cube[54];
	for (int i = 0; i < 54; i++) {
		sticker_cube[i] = (Sticker[]){
			['W'] = WHITE,
			['G'] = GREEN,
			['R'] = RED,
			['B'] = BLUE,
			['O'] = ORANGE,
			['Y'] = YELLOW
		}[str[i] & 0xDF];
	}
	return stickersToCube(sticker_cube);
}

int main() {
	Cube cube;
	char str[512];
	scanf("%s", str);
	parse_input(str);
	return 0;
}

/*
Niniejszy program jest wolnym oprogramowaniem; możesz go
rozprowadzać dalej i / lub modyfikować na warunkach Powszechnej
Licencji Publicznej GNU, wydanej przez Fundację Wolnego
Oprogramowania - według wersji 2 tej Licencji lub(według twojego
wyboru) którejś z późniejszych wersji.

Niniejszy program rozpowszechniany jest z nadzieją, iż będzie on
użyteczny - jednak BEZ JAKIEJKOLWIEK GWARANCJI, nawet domyślnej
gwarancji PRZYDATNOŚCI HANDLOWEJ albo PRZYDATNOŚCI DO OKREŚLONYCH
ZASTOSOWAŃ.W celu uzyskania bliższych informacji sięgnij do
Powszechnej Licencji Publicznej GNU.

Z pewnością wraz z niniejszym programem otrzymałeś też egzemplarz
Powszechnej Licencji Publicznej GNU(GNU General Public License);
jeśli nie - napisz do Free Software Foundation, Inc., 59 Temple
Place, Fifth Floor, Boston, MA  02110 - 1301  USA
*/

#define GLM_FORCE_RADIANS

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <stdlib.h>
#include <stdio.h>

#include "floor.h"
#include "roof.h"
#include "bar.h"

#include "model.h"
#include  "cube.h"

#include "constants.h"

#include "lodepng.h"
#include "shaderprogram.h"
#include "GL/glu.h"
#include <vector>



float speed_x = 0;//[radiany/s]
float speed_y = 0;//[radiany/s]

glm::vec3 camera_position = glm::vec3(5.0f, 3.0f, -15.0f);
glm::vec3 camera_front = glm::vec3(0.0f, 0.0f, 1.0f);
glm::vec3 camera_up = glm::vec3(0.0f, 1.0f, 0.0f);

float yaw = 90.0f;
float pitch = 0.0f;
float camera_speed = 0.1f;
float mouse_sensitivity = 0.1f;

float lastX = 400, lastY = 300;
bool firstMouse = true;


GLuint  texture_floor, texture_column, texture_roof;


ShaderProgram* sp;

float aspectRatio = 1;

int vertexCount = 3;
float elapsedTime = 0.0f;
bool up = false;
int count = 0;


//Procedura obsługi błędów
void error_callback(int error, const char* description) {
	fputs(description, stderr);
}
void updateCameraDirection() {
	glm::vec3 direction;
	direction.x = cos(glm::radians(pitch)) * cos(glm::radians(yaw));
	direction.y = sin(glm::radians(pitch));
	direction.z = cos(glm::radians(pitch)) * sin(glm::radians(yaw));
	camera_front = glm::normalize(direction);
}
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
	if (action != GLFW_PRESS && action != GLFW_REPEAT) return;

	// wektor przód/tył *poziomo* 
	glm::vec3 forward = glm::normalize(glm::vec3(camera_front.x, 0.0f, camera_front.z));
	// wektor w prawo po poziomie
	glm::vec3 right = glm::normalize(glm::cross(forward, camera_up));

	if (key == GLFW_KEY_W) {
		camera_position += camera_speed * forward;
	}
	if (key == GLFW_KEY_S) {
		camera_position -= camera_speed * forward;
	}
	if (key == GLFW_KEY_A) {
		camera_position -= camera_speed * right;
	}
	if (key == GLFW_KEY_D) {
		camera_position += camera_speed * right;
	}

	// strzałka w górę / w dół: zmiana wysokości
	if (key == GLFW_KEY_UP) {
		camera_position.y += camera_speed;
	}
	if (key == GLFW_KEY_DOWN) {
		camera_position.y -= camera_speed;
	}
}

void mouse_callback(GLFWwindow* window, double xpos, double ypos) {
	if (firstMouse) {
		lastX = xpos;
		lastY = ypos;
		firstMouse = false;
	}

	float xoffset = xpos - lastX;
	float yoffset = lastY - ypos; // odwrotne osi Y

	lastX = xpos;
	lastY = ypos;

	xoffset *= mouse_sensitivity;
	yoffset *= mouse_sensitivity;

	yaw += xoffset;
	pitch += yoffset;

	if (pitch > 89.0f)
		pitch = 89.0f;
	if (pitch < -89.0f)
		pitch = -89.0f;

	updateCameraDirection();
}


GLuint readTexture(const char* filename) {
	GLuint tex;
	glActiveTexture(GL_TEXTURE0);

	//Wczytanie do pamięci komputera
	std::vector<unsigned char> image;   //Alokuj wektor do wczytania obrazka
	unsigned width, height;   //Zmienne do których wczytamy wymiary obrazka
	//Wczytaj obrazek
	unsigned error = lodepng::decode(image, width, height, filename);

	//Import do pamięci karty graficznej
	glGenTextures(1, &tex); //Zainicjuj jeden uchwyt
	glBindTexture(GL_TEXTURE_2D, tex); //Uaktywnij uchwyt


	glGenTextures(1, &tex); //Zainicjuj jeden uchwyt
	glBindTexture(GL_TEXTURE_2D, tex); //Uaktywnij uchwyt
	//Wczytaj obrazek do pamięci KG skojarzonej z uchwytem
	glTexImage2D(GL_TEXTURE_2D, 0, 4, width, height, 0,
		GL_RGBA, GL_UNSIGNED_BYTE, (unsigned char*)image.data());
	glTexParameteri(GL_TEXTURE_2D,
		GL_TEXTURE_WRAP_S,
		GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D,
		GL_TEXTURE_WRAP_T,
		GL_REPEAT);

	glTexParameteri(GL_TEXTURE_2D,
		GL_TEXTURE_MIN_FILTER,
		GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, 
		GL_TEXTURE_MAG_FILTER, 
		GL_NEAREST);
	glGenerateMipmap(GL_TEXTURE_2D);
	return tex;
}

//Procedura inicjująca
void initOpenGLProgram(GLFWwindow* window) {

	//************Tutaj umieszczaj kod, który należy wykonać raz, na początku programu************
	glClearColor(0, 0, 0, 1); //Ustaw kolor czyszczenia bufora kolorów
	glEnable(GL_DEPTH_TEST); //Włącz test głębokości na pikselach
	glfwSetKeyCallback(window, key_callback);


	sp = new ShaderProgram("v_simplest.glsl", NULL, "f_simplest.glsl");

	texture_roof = readTexture("stone_roof1.png");
	texture_floor = readTexture("stone_floor4.png");
	texture_column = readTexture("stone_column1.png");


}



//Zwolnienie zasobów zajętych przez program
void freeOpenGLProgram(GLFWwindow* window) {

	//************Tutaj umieszczaj kod, który należy wykonać po zakończeniu pętli głównej************
	glDeleteTextures(1, &texture_roof);
	delete sp;

}
void updateElapsedTime() {
	static double lastTime = glfwGetTime();
	double currentTime = glfwGetTime();
	elapsedTime += static_cast<float>(currentTime - lastTime);
	lastTime = currentTime;
}


void draw_bar(glm::mat4 P, glm::mat4 V, glm::mat4 M) {
	sp->use();

	glUniformMatrix4fv(sp->u("P"), 1, false, glm::value_ptr(P));
	glUniformMatrix4fv(sp->u("V"), 1, false, glm::value_ptr(V));
	glUniformMatrix4fv(sp->u("M"), 1, false, glm::value_ptr(M));

	glEnableVertexAttribArray(sp->a("vertex"));
	glEnableVertexAttribArray(sp->a("texCoord"));

	glVertexAttribPointer(sp->a("vertex"), 3, GL_FLOAT, false, 5 * sizeof(GLfloat), barVertices);
	glVertexAttribPointer(sp->a("texCoord"), 2, GL_FLOAT, false, 5 * sizeof(GLfloat), barVertices + 3);


	glEnableVertexAttribArray(sp->a("normal"));
	glVertexAttribPointer(sp->a("normal"), 3, GL_FLOAT, false, 0, barNormals);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture_column); 
	glUniform1i(sp->u("column"), 0);

	glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, barIndices);

	glDisableVertexAttribArray(sp->a("vertex"));
	glDisableVertexAttribArray(sp->a("texCoord"));
	glDisableVertexAttribArray(sp->a("normal"));
}

void draw_floor(glm::mat4 P, glm::mat4 V, glm::mat4 M) {

	M = glm::scale(M, glm::vec3(2.0f, 1.0f, 0.25)); 
	M = glm::translate(M, glm::vec3(0.0f, 1.0f, 0.0f));
	//M = glm::rotate(M, glm::radians(90.0f), glm::vec3(0.0f, 0.0f, 0.0f));

	sp->use(); //Aktywuj program cieniujący

	glUniformMatrix4fv(sp->u("P"), 1, false, glm::value_ptr(P)); //Załaduj do programu cieniującego macierz rzutowania
	glUniformMatrix4fv(sp->u("V"), 1, false, glm::value_ptr(V)); //Załaduj do programu cieniującego macierz widoku
	glUniformMatrix4fv(sp->u("M"), 1, false, glm::value_ptr(M)); //Załaduj do programu cieniującego macierz modelu


	glEnableVertexAttribArray(sp->a("vertex"));  //Włącz przesyłanie danych do atrybutu vertex
	glVertexAttribPointer(sp->a("vertex"), 4, GL_FLOAT, false, 0, floorVertices); //Wskaż tablicę z danymi dla atrybutu vertex



	glEnableVertexAttribArray(sp->a("normal"));  //Włącz przesyłanie danych do atrybutu normal
	glVertexAttribPointer(sp->a("normal"), 4, GL_FLOAT, false, 0, floorNormals1); //Wskaż tablicę z danymi dla atrybutu normal

	glEnableVertexAttribArray(sp->a("texCoord"));  //Włącz przesyłanie danych do atrybutu texCoord0
	glVertexAttribPointer(sp->a("texCoord"), 2, GL_FLOAT, false, 0, floorTexCoords); //Wskaż tablicę z danymi dla atrybutu texCoord0

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture_floor);
	glUniform1i(sp->u("roof"), 0);


	glDrawArrays(GL_TRIANGLES, 0, floorVertexCount);

	glDisableVertexAttribArray(sp->a("vertex"));
	glDisableVertexAttribArray(sp->a("texCoord"));
	glDisableVertexAttribArray(sp->a("normal"));

}


void texturing_bar(glm::mat4 P, glm::mat4 V, glm::mat4 M, int sides) {
	sp->use();
	glUniformMatrix4fv(sp->u("P"), 1, false, glm::value_ptr(P));
	glUniformMatrix4fv(sp->u("V"), 1, false, glm::value_ptr(V));
	glUniformMatrix4fv(sp->u("M"), 1, false, glm::value_ptr(M));

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture_column);
	glUniform1i(sp->u("column"), 0);

	const int N = (sides + 1) * 2;
	static std::vector<GLfloat> data;
	data.resize(N * (3 + 3 + 2)); // 3 pozycja + 3 normal + 2 texCoord

	float radius = 1.0f, height = 3.0f;
	for (int i = 0; i <= sides; ++i) {
		float theta = 2.0f * glm::pi<float>() * i / sides;
		float x = radius * cos(theta), z = radius * sin(theta);
		float u = float(i) / sides;

		int base = i * 2 * 8; // 8 floats per vertex * 2 vertices per slice

		// dolny wierzchołek
		data[base + 0] = x;
		data[base + 1] = 0.0f;
		data[base + 2] = z;
		data[base + 3] = cos(theta);
		data[base + 4] = 0.0f;
		data[base + 5] = sin(theta);
		data[base + 6] = u;
		data[base + 7] = 0.0f;

		// górny wierzchołek
		data[base + 8] = x;
		data[base + 9] = height;
		data[base + 10] = z;
		data[base + 11] = cos(theta);
		data[base + 12] = 0.0f;
		data[base + 13] = sin(theta);
		data[base + 14] = u;
		data[base + 15] = 1.0f;
	}

	// jedno VAO/VBO na stosie
	GLuint VBO;
	glGenBuffers(1, &VBO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, data.size() * sizeof(GLfloat), data.data(), GL_DYNAMIC_DRAW);

	// Atrybuty z interleaved stride = 8 * sizeof(float)
	GLsizei stride = 8 * sizeof(GLfloat);
	glEnableVertexAttribArray(sp->a("vertex"));
	glVertexAttribPointer(sp->a("vertex"), 3, GL_FLOAT, false, stride, (void*)0);
	glEnableVertexAttribArray(sp->a("normal"));
	glVertexAttribPointer(sp->a("normal"), 3, GL_FLOAT, false, stride, (void*)(3 * sizeof(GLfloat)));
	glEnableVertexAttribArray(sp->a("texCoord"));
	glVertexAttribPointer(sp->a("texCoord"), 2, GL_FLOAT, false, stride, (void*)(6 * sizeof(GLfloat)));

	glDrawArrays(GL_TRIANGLE_STRIP, 0, N);

	// sprzątanie
	glDisableVertexAttribArray(sp->a("vertex"));
	glDisableVertexAttribArray(sp->a("normal"));
	glDisableVertexAttribArray(sp->a("texCoord"));
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDeleteBuffers(1, &VBO);
}


void draw_roof(glm::mat4 P, glm::mat4 V, glm::mat4 M) {


	M = glm::scale(M, glm::vec3(5.0f, 2.0f, 3.8)); // Skalowanie dachu wzdłuż osi x, y i z odpowiednio
	M = glm::translate(M, glm::vec3(-1.0f, 2.5f, 0.0f));
	M = glm::rotate(M, glm::radians(0.0f), glm::vec3(0.0f, 0.0f, 1.0f));

	sp->use(); //Aktywuj program cieniujący

	glUniformMatrix4fv(sp->u("P"), 1, false, glm::value_ptr(P)); //Załaduj do programu cieniującego macierz rzutowania
	glUniformMatrix4fv(sp->u("V"), 1, false, glm::value_ptr(V)); //Załaduj do programu cieniującego macierz widoku
	glUniformMatrix4fv(sp->u("M"), 1, false, glm::value_ptr(M)); //Załaduj do programu cieniującego macierz modelu


	glEnableVertexAttribArray(sp->a("vertex"));  //Włącz przesyłanie danych do atrybutu vertex
	glVertexAttribPointer(sp->a("vertex"), 4, GL_FLOAT, false, 0, roofVertices); //Wskaż tablicę z danymi dla atrybutu vertex



	glEnableVertexAttribArray(sp->a("normal"));  //Włącz przesyłanie danych do atrybutu normal
	glVertexAttribPointer(sp->a("normal"), 4, GL_FLOAT, false, 0, roofNormals); //Wskaż tablicę z danymi dla atrybutu normal

	glEnableVertexAttribArray(sp->a("texCoord"));  //Włącz przesyłanie danych do atrybutu texCoord0
	glVertexAttribPointer(sp->a("texCoord"), 2, GL_FLOAT, false, 0, roofTexCoords); //Wskaż tablicę z danymi dla atrybutu texCoord0

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture_roof);
	glUniform1i(sp->u("roof"), 0);


	glDrawArrays(GL_TRIANGLES, 0, roofVertexCount);

	glDisableVertexAttribArray(sp->a("vertex"));
	glDisableVertexAttribArray(sp->a("texCoord"));
	glDisableVertexAttribArray(sp->a("normal"));



}


// Procedura rysująca zawartość sceny
void drawScene(GLFWwindow* window) {

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Wyczyść bufor koloru i bufor głębokości



	glm::mat4 M = glm::mat4(1.0f); // Zainicjuj macierz modelu macierzą jednostkową
	glfwSetKeyCallback(window, key_callback);
	glfwSetCursorPosCallback(window, mouse_callback);
	glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
	glm::mat4 V = glm::lookAt(camera_position, camera_position + camera_front, camera_up);
	// M = glm::rotate(M, angle_y, glm::vec3(0.0f, 1.0f, 0.0f)); // Pomnóż macierz modelu razy macierz obrotu o kąt angle wokół osi Y
	// M = glm::rotate(M, angle_x, glm::vec3(1.0f, 0.0f, 0.0f)); // Pomnóż macierz modelu razy macierz obrotu o kąt angle wokół osi X
	//glm::mat4 V = glm::lookAt(camera_position, camera_target, camera_up);
	// glm::mat4 V = glm::lookAt(glm::vec3(0.0f, 0.0f, -5.0f), glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f)); // Wylicz macierz widoku
	glm::mat4 P = glm::perspective(glm::radians(50.0f), 1.0f, 1.0f, 50.0f); // Wylicz macierz rzutowania

	glUniform4f(sp->u("lp"), 0, 0, -6, 1);

	// Dach
	M = glm::mat4(1.0f);

	draw_roof(P, V, M);

	M = glm::scale(M, glm::vec3(0.5f, 0.5f, 0.5f));


	// Podstawy i schody
	M = glm::scale(M, glm::vec3(1.0f, 0.95f, 7.5f));
	M = glm::translate(M, glm::vec3(0.0f, 8.5f, 0.0f));
	draw_floor(P, V, M); // Zamiast texFloor

	// Najmniejsza podstawa
	M = glm::translate(M, glm::vec3(0.0f, -10.0f, 0.0f));
	draw_floor(P, V, M); // Zamiast texFloor
; 
	for (int i = 0;i < 3;i++) {
		M = glm::scale(M, glm::vec3(1.1f, 1.0f, 1.1f));
		M = glm::translate(M, glm::vec3(0.0f, -0.5f, 0.0f));
		draw_floor(P, V, M);
	}



    //kolumny
	int numColumns = 4;       // liczba kolumn wzdłuż rzędu
	float spacing = 3.0f;     // odległość między kolumnami
	float rowSpacing = 4.0f;  // odległość między rzędami kolumn
	float diff = 2.0f;
	for (int row = 0; row <= 3; row++) {
		for (int col = 0; col <= numColumns; col++) {
			M = glm::mat4(1.0f);
			M = glm::translate(M, glm::vec3((rowSpacing)-(col * diff), 0.0f, (spacing)));
			M = glm::scale(M, glm::vec3(0.5f, 1.65f, 0.5f));
			texturing_bar(P, V, M, 20);
		}
		spacing -= diff;
	}

	glfwSwapBuffers(window); //Skopiuj bufor tylny do bufora przedniego

}


int main(void)
{
	GLFWwindow* window; //Wskaźnik na obiekt reprezentujący okno

	glfwSetErrorCallback(error_callback);//Zarejestruj procedurę obsługi błędów

	if (!glfwInit()) { //Zainicjuj bibliotekę GLFW
		fprintf(stderr, "Nie można zainicjować GLFW.\n");
		exit(EXIT_FAILURE);
	}

	window = glfwCreateWindow(1000, 1000, "OpenGL", NULL, NULL);  //Utwórz okno 500x500 o tytule "OpenGL" i kontekst OpenGL.

	if (!window) //Jeżeli okna nie udało się utworzyć, to zamknij program
	{
		fprintf(stderr, "Nie można utworzyć okna.\n");
		glfwTerminate();
		exit(EXIT_FAILURE);
	}

	glfwMakeContextCurrent(window); //Od tego momentu kontekst okna staje się aktywny i polecenia OpenGL będą dotyczyć właśnie jego.
	glfwSwapInterval(1); //Czekaj na 1 powrót plamki przed pokazaniem ukrytego bufora

	if (glewInit() != GLEW_OK) { //Zainicjuj bibliotekę GLEW
		fprintf(stderr, "Nie można zainicjować GLEW.\n");
		exit(EXIT_FAILURE);
	}

	initOpenGLProgram(window); //Operacje inicjujące

	// Główna pętla
	glfwSetTime(0); //Wyzeruj licznik czasu
	while (!glfwWindowShouldClose(window)) //Tak długo jak okno nie powinno zostać zamknięte
	{
		// Nie potrzebujemy już zmiennej angle_x i angle_y
		glfwSetTime(0); //Wyzeruj licznik czasu
		//glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		drawScene(window); //Wykonaj procedurę rysującą
		glfwPollEvents(); //Wykonaj procedury callback w zalezności od zdarzeń jakie zaszły.
	}

	freeOpenGLProgram(window);

	glfwDestroyWindow(window); //Usuń kontekst OpenGL i okno
	glfwTerminate(); //Zwolnij zasoby zajęte przez GLFW
	exit(EXIT_SUCCESS);
}

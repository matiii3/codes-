#version 330

//Zmienne jednorodne
uniform mat4 P;
uniform mat4 V;
uniform mat4 M;

//Atrybuty
in vec4 vertex; //wspolrzedne wierzcholka w przestrzeni modelu
in vec4 color; //kolor zwi¹zany z wierzcho³kiem
in vec4 normal; //wektor normalny w przestrzeni modelu
in vec2 texCoord;

//Zmienne interpolowane
out vec4 ic;
out vec4 l1;
out vec4 l2;
out vec4 n;
out vec4 v;
out vec2 iTexCoord0; 

void main(void) {
    vec4 lp1 = vec4(  8, 12, -10, 1);; //pozycja œwiat³a 1
    vec4 lp2 = vec4(-3, 4, 6, 1);// œwiat³o 2
    l1 = normalize(V * lp1 - V*M*vertex); //wektor do œwiat³a w przestrzeni oka
    l2 = normalize(V * lp2 - V*M*vertex);
    v = normalize(vec4(0, 0, 0, 1) - V * M * vertex); //wektor do obserwatora w przestrzeni oka
    n = normalize(V * M * normal); //wektor normalny w przestrzeni oka
    
    iTexCoord0 = texCoord;
     //
     
     ic = color;
    {
        // === parametry lamp ===
        vec4 amb1 = vec4(0.2,0.15,0.1,1.0);
        vec4 dif1 = vec4(1.0,0.9,0.7,1.0);
        vec4 spec1= vec4(1.0,1.0,0.9,1.0);
        float c1=1.0, l1a=0.09, q1=0.032;

        vec4 amb2 = vec4(0.05,0.1,0.2,1.0);
        vec4 dif2 = vec4(0.3,0.5,1.0,1.0);
        vec4 spec2= vec4(0.5,0.7,1.0,1.0);
        float c2=1.0, l2a=0.14, q2=0.07;

        vec4 base = color;        // Twój kolor z wierzcho³ka
        vec3 N = normalize(n.xyz);
        vec3 Vv= normalize(v.xyz);

        // Lamp 1
        vec3 L1 = normalize(l1.xyz);
        float df1 = max(dot(N,L1),0.0);
        vec3 R1  = reflect(-L1, N);
        float sp1= pow(max(dot(Vv,R1),0.0),32.0);
        float d1  = length(lp1.xyz - (V*M*vertex).xyz);
        float att1 = 1.0/(c1 + l1a*d1 + q1*d1*d1);
        vec4 col1 = (amb1*base + dif1*df1*base + spec1*sp1) * att1;
        
        // Lamp 2
        vec3 L2 = normalize(l2.xyz);
        float df2 = max(dot(N,L2),0.0);
        vec3 R2  = reflect(-L2, N);
        float sp2= pow(max(dot(Vv,R2),0.0),32.0);
        float d2  = length(lp2.xyz - (V*M*vertex).xyz);
        float att2 = 1.0/(c2 + l2a*d2 + q2*d2*d2);
        vec4 col2 = (amb2*base + dif2*df2*base + spec2*sp2) * att2;

        ic = col1 + col2;
    }
    
    gl_Position=P*V*M*vertex;
}

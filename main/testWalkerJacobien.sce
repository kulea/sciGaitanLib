// 21 janvier 2013
// construction du modele du bonhomme
// modelisation 2 D 5 segments pour le bonhomme et 
// le deambulateur est un objet rigide a trois branches

// posture 
q1 = 10*%pi/180 ;
q2 = -30*%pi/180 ;
q3 = 50*%pi/180 ;
q4 = 160*%pi/180 ;
q5 = -30*%pi/180 ;
q6 = 90*%pi/180-(q1+q2+q3+q4+q5);//+5*%pi/180;


//-------- Parametres du robot ------- //

// les tailles sont tirees de DUMAS 2007 pour un homme
// hauteur du pied en m
d1 = .05;
// hauteur du tibias
d2 = .432;
// hauteur de la jambe
d3 = .433;
// hauteur du torse
d4 = .477;
// longueur du bras
d5 = .271;
// longueur de l'avant bras
d6 = .283;
// FIXME : pour l'instant les dimension du deambulateur sont donnees  titre indicatif.
// largeur deambulateur
dw = 0.6;
// hauteur deambulateur
dh = 0.8;

d = [d1, d2, d3, d4, d5, d6, dh, dw];
q = [q1,q2,q3,q4,q5,q6];


// ----------------- // 
// Calcul du MGD 
//-------------------//
M_base0 = homogeneousMatrixFromPos([0 0 0 0 -%pi/2 0]); // expression du premier repere dans le monde
[M_01, M_12, M_23, M_34, M_45, M_56, A_0, B_0, C_0, P_0] = computeMGDsagitalMan(d,q);
M_02 = M_01*M_12;
M_03 = M_01*M_12*M_23;
M_04 = M_01*M_12*M_23*M_34;
M_05 = M_01*M_12*M_23*M_34*M_45;
M_06 = M_01*M_12*M_23*M_34*M_45*M_56;




// ----------------- // 
// Affichage 
//-------------------//
scale =.2;

h1 = createFigure3D(1,"Robot Frame position",2);
Camera3DDraw(scale,M_base0)
show_pixmap()
Camera3DDrawColor(scale,M_base0*M_01,1)
Camera3DDrawColor(scale,M_base0*M_02,2)
Camera3DDrawColor(scale,M_base0*M_03,3)
Camera3DDrawColor(scale,M_base0*M_04,4)
Camera3DDrawColor(scale,M_base0*M_05,5)
Camera3DDrawColor(scale,M_base0*M_06,6)
show_pixmap()  
  

// le robot est un robot plan sur xy
sommets=[zeros(4,1) P_0 A_0 C_0 A_0 P_0(:,$) B_0];
y = sommets (1,:);
x = sommets (2,:);

//trac de la figure
xset("window",2);
xset("pixmap",1);
clear_pixmap()//et buffer
h1=scf(2);
h1.figure_name = "Sagital plane";
ha=h1.children;
ha.box="on"; 
ha.view="2d";
ha.thickness=1;
ha.foreground=0;
axe=gca(); // recupere un pointeur sur les axes
axe.data_bounds=[[-0.1 2]'; [-0.1 2]'];
axe.grid =[0.1 0.1 -0.1];
axe.auto_clear = "off" ;

plot(x,y);
show_pixmap()



//---------------//
// MGD direct
//---------------//
[Mdirect_01, Mdirect_02, Mdirect_03, Mdirect_04, Mdirect_05, Mdirect_06, Adirect_0, Bdirect_0, Cdirect_0, Pdirect_0] = computeMGDsagitalManDir(d,q);


// ----------------- // 
// Calcul du Jacobien 
//-------------------//
J06 = computeJ06SagMan(d,q)

// soit la vitesse de l'effecteur
v = [0 1 0];
qprec = q';

dt =0.1;



for i=0:10
  dotq = pinv(J06)*v';
  qnew= qprec+dotq*dt;
  [M_01, M_12, M_23, M_34, M_45, M_56, A_0, B_0, C_0, P_0] = computeMGDsagitalMan(d,qnew);
  // le robot est un robot plan sur xy
  sommets=[zeros(4,1) P_0 A_0 C_0 A_0 P_0(:,$) B_0];
  y = sommets (1,:);
  x = sommets (2,:);
  plot(x,y,'r');
  show_pixmap()

  J06 = computeJ06SagMan(d,qnew);
  qprec=qnew;
end




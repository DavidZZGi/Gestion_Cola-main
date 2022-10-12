class Municipio{
int idMunicipio;
int idProvincia;
String nombre;
String nombreCorto;
int poblacion;

Municipio({required this.idMunicipio,required this.nombre,required this.poblacion,required this.nombreCorto,required this.idProvincia});

String getnombre()=>this.nombre;
int getpoblacion()=>this.poblacion;

void setNombre(String value){
  this.nombre=value;
}

void setPoblacion(int value){
  this.poblacion=value;
}


}
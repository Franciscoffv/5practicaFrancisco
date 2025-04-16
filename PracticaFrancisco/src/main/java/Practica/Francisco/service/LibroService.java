/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Practica.Francisco.service;

import Practica.Francisco.domain.Libro;
import java.util.List;

/**
 *
 * @author Francisco
 */
public interface LibroService {  
    public List<Libro> getLibros(boolean activos);
 
    public Libro getLibro(Libro libro);

    public void save(Libro libro);
  
    public void delete(Libro libro);
}

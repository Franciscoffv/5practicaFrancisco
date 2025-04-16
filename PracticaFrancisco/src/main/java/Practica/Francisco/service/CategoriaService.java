/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Practica.Francisco.service;

import Practica.Francisco.domain.Categoria;
import java.util.List;

/**
 *
 * @author Francisco
 */
public interface CategoriaService {
 
    public List<Categoria> getCategorias(boolean activos);
 
    public Categoria getCategoria(Categoria categoria);

    public void save(Categoria categoria);
  
    public void delete(Categoria categoria);
}

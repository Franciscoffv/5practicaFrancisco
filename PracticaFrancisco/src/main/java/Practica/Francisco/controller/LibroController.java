/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Practica.Francisco.controller;

import Practica.Francisco.domain.Libro;
import Practica.Francisco.service.CategoriaService;
import Practica.Francisco.service.LibroService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author Francisco
 */
@Controller
@RequestMapping("/libro")
public class LibroController {
  
    @Autowired
    private LibroService libroService;
    @Autowired
    private CategoriaService categoriaService;
    
    @GetMapping("/listado")
    private String listado(Model model) {
        var libros = libroService.getLibros(false);
        model.addAttribute("libros", libros);
        var categorias = categoriaService.getCategorias(false);
        model.addAttribute("categorias", categorias);
        model.addAttribute("totalLibros",libros.size());
        return "/libro/listado";
    }
    
     @GetMapping("/nuevo")
    public String libroNuevo(Libro libro) {
        return "/libro/modifica";
    }
    
    @PostMapping("/guardar")
    public String libroGuardar(Libro libro) {        
        libroService.save(libro);
        return "redirect:/libro/listado";
    }

    @GetMapping("/eliminar/{idLibro}")
    public String libroEliminar(Libro libro) {
        libroService.delete(libro);
        return "redirect:/libro/listado";
    }

    @GetMapping("/modificar/{idLibro}")
    public String libroModificar(Libro libro, Model model) {
        libro = libroService.getLibro(libro);
        model.addAttribute("libro", libro);
        
        var categorias = categoriaService.getCategorias(false);
        model.addAttribute("categorias", categorias);
        
        return "/libro/modifica";
    }   
}


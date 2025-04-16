/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Practica.Francisco.service;

import org.springframework.security.core.userdetails.*;

/**
 *
 * @author Francisco
 */
public interface UsuarioDetailsService {
    public UserDetails loadUserByUsername (String username) throws UsernameNotFoundException;
}


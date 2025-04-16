/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Practica.Francisco.service.impl;

import Practica.Francisco.dao.UsuarioDao;
import Practica.Francisco.domain.Rol;
import Practica.Francisco.domain.Usuario;
import Practica.Francisco.service.UsuarioDetailsService;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Francisco
 */
    @Service("userDetailsService")
public class UsuarioDetailsServiceImpl implements UsuarioDetailsService, UserDetailsService {
    @Autowired
    private UsuarioDao usuarioDao;
    
    @Override
    @Transactional(readOnly=true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioDao.findByUsername(username);
        
        if (usuario == null){
            throw new UsernameNotFoundException(username);
        }
        var roles = new ArrayList <GrantedAuthority>();
          for (Rol rol : usuario.getRoles()) {
         roles.add(new SimpleGrantedAuthority("ROLE_" + rol.getNombre()));
        }
        return new User(usuario.getUsername(), usuario.getPassword(), roles);
    }
}


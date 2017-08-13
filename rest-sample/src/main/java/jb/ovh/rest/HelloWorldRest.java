package jb.ovh.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * @author JLY - a511671
 */
@Path(value = "/")
public class HelloWorldRest {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String hello(){
        return "Hello";
    }
}

package jb.ovh.rest;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

/**
 * @author JLY - a511671
 */
@Path("mock")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class MockRest {

    @POST
    public Object returnSame(Object o){
        return o;
    }

    @PUT
    public Object returnSameForPut(Object o){
        return o;
    }
}

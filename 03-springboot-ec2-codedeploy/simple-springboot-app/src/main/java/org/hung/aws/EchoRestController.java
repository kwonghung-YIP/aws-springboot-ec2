package org.hung.aws;

import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

import java.net.Inet4Address;
import java.net.UnknownHostException;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Slf4j
@RestController
public class EchoRestController {

    @GetMapping("/echo")
    public String getMethodName(@RequestParam String name) {
        log.info("received request:"+name);
        String localhost = "";
        try {
            localhost = Inet4Address.getLocalHost().getHostName();
        } catch (UnknownHostException e) {
            log.error("Failed to get localhost hostname", e);
        }
        return "Hey " + name + " from " + localhost + "!";    }
    
}

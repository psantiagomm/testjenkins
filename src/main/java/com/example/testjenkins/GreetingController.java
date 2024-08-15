package com.example.testjenkins;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertySource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.testjenkins.config.Messages;

@RestController
@RefreshScope
public class GreetingController {
	
	@Value("${greeting.template}")
	private String template;
	
	@Value("${show.properties.contains}")
	private List<String> showProperties;
	
	@Autowired
    private ConfigurableEnvironment env;
	
	@Autowired
	Messages messages;
	
	private final AtomicLong counter = new AtomicLong();
	
	@GetMapping("/greeting")
	public Greeting greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new Greeting(counter.incrementAndGet(), String.format(template, name));
	}
	
	@GetMapping("/env")
	public Map<String, String> env() {
		Map<String, String> properties = new HashMap<>();
		properties.put("app.message", messages.getKey("app.message"));
		properties.put("app.message.override", messages.getKey("app.message.override"));
		
		for (PropertySource<?> propertySource : env.getPropertySources()) {
            System.out.println("Source: " + propertySource.getName());
            if (propertySource.getSource() instanceof java.util.Map) {
                for (Object key : ((java.util.Map<?, ?>) propertySource.getSource()).keySet()) {
                    String propertyName = key.toString();
                    String propertyValue = env.getProperty(propertyName);
                    
                    if(showProperty(propertyName)) {
                    	System.out.println(propertyName + " = " + propertyValue);
                    	properties.put(propertyName, propertyValue);
                    }
                    
                }
            }
        }
		return properties;
	}

	private boolean showProperty(String propertyName) {
		for(String text: showProperties) {
			if(propertyName.contains(text)) {
				return true;
			}
		}
		return false;
	}
	
	
}

package com.project.listner;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Application Lifecycle Listener implementation class AppListner
 *
 */
public class AppListner implements ServletContextListener {

	
	@Value("${aws.staticUrl}")
	private String staticUrl;
    /**
     * Default constructor. 
     */
    public AppListner() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent sce)  { 
         // TODO Auto-generated method stub
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent sce)  { 
    	ServletContext application= sce.getServletContext();
    	
    	WebApplicationContextUtils.getRequiredWebApplicationContext(application)
    								.getAutowireCapableBeanFactory()
    								.autowireBean(this);
    	application.setAttribute("staticUrl", staticUrl);
    	application.setAttribute("appRoot", application.getContextPath());
    
    }
	
}

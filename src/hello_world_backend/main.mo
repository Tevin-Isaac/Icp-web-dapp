
actor class GBVApp {
  var incidents : [Incident] = [];

  public shared({caller}) func reportIncident(description: Text, multimediaHash: Text) : async Nat {
    let incident : Incident = {
      id = Array.length(incidents) + 1;
      timestamp = Time.now();
      description = description;
      multimediaHash = multimediaHash;
    };
    incidents := Array.append(incidents, [incident]);
    return incident.id;
  }

  public query shared({caller}) func getIncident(id: Nat) : async ?Incident {
    if (id > 0 && id <= Array.length(incidents)) {
      return incidents[id - 1];
    } else {
      return null;
    }
  }
};

// Define a record to represent a support service
type SupportService = {
  id: Nat;
  name: Text;
  category: Text;
  description: Text;
  location: Text;
  operatingHours: Text;
  contactInfo: Text;
  accessibilityFeatures: [Text];
};

// Define the main canister entry point for the service directory
public type ServiceDirectory = actor {
  // Store support services
  var services : [SupportService] = [];

  // Function to add a new support service to the directory
  public shared({name, category, description, location, operatingHours, contactInfo, accessibilityFeatures} :
                {name: Text; category: Text; description: Text; location: Text; operatingHours: Text;
                 contactInfo: Text; accessibilityFeatures: [Text]}) : async Nat {
    let newServiceId = Array.length(services) + 1;
    let newService : SupportService = {
      id = newServiceId;
      name = name;
      category = category;
      description = description;
      location = location;
      operatingHours = operatingHours;
      contactInfo = contactInfo;
      accessibilityFeatures = accessibilityFeatures;
    };
    services := services # [newService];
    return newServiceId;
  };

  // Function to retrieve information about a specific service
  public query shared({serviceId} : {serviceId: Nat}) : async ?SupportService {
    if serviceId <= Array.length(services) {
      return services[serviceId - 1];
    } else {
      return null;
    }
  };

  // Function to get a list of all services in the directory
  public query shared() : async [SupportService] {
    return services;
  };

  // Function to search for support services based on criteria
  public query shared searchServices({query} : {query: Text}) : async [SupportService] {
    return Array.filter((service) =>
      Text.contains(service.name, query) or
      Text.contains(service.description, query) or
      Text.contains(service.category, query) or
      Text.contains(service.location, query),
      services);
  };

  // Adding support services to the directory
  public shared async func addExampleServices() : async {
    await ServiceDirectory.add({
      name = "Women's Shelter";
      category = "Shelter";
      description = "Provides a safe and supportive environment for women in need.";
      location = "123 Main Street, Kawangware";
      operatingHours = "24/7";
      contactInfo = "Phone: (254) 123-4567, Email: contact@womensshelter.org, Website: www.womensshelter.org";
      accessibilityFeatures = ["Wheelchair accessible", "Language support: English, Spanish"];
    });

    await ServiceDirectory.add({
      name = "Legal Aid Center";
      category = "Legal Aid";
      description = "Offers legal assistance for survivors of gender-based violence.";
      location = "456 Legal Avenue, Kilimani";
      operatingHours = "Monday to Friday, 9:00 AM to 5:00 PM";
      contactInfo = "Phone: (254) 789-0123, Email: legalaid@justicecenter.org, Website: www.legalaidcenter.org";
      accessibilityFeatures = ["Language support: English, Spanish", "Legal consultations by appointment"];
    });

    
  };
};
package org.example;

import jade.core.AID;
import jade.core.Agent;
import jade.domain.DFService;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;
import jade.wrapper.ContainerController;
import lombok.SneakyThrows;

import java.util.Arrays;

public class Remove {
    @SneakyThrows
    public static void removeAgents(Agent agent, String type) {
        var dfd = new DFAgentDescription();

        var sd = new ServiceDescription();
        sd.setType(type);

        dfd.addServices(sd);

        DFAgentDescription[] ad = DFService.search(agent, dfd);

        Arrays.stream(ad).forEach(ag -> removeAgent(agent.getContainerController(), ag.getName()));
    }

    @SneakyThrows
    public static void removeAgent(ContainerController controller, AID agentAid) {
        controller.getAgent(agentAid.getLocalName()).kill();
    }
}

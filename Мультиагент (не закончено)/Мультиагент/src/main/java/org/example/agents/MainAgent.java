package org.example.agents;

import jade.core.AID;
import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.domain.DFService;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;
import jade.domain.FIPAException;
import jade.lang.acl.ACLMessage;
import javassist.compiler.ast.Visitor;
import lombok.SneakyThrows;
import org.example.Remove;
import org.example.behaviour.ReceiveMessageBehaviour;
import org.example.behaviour.SendMessageBehaviour;
import org.example.config.JadeAgent;

import static org.example.util.ACLMessageUtil.getContent;

@JadeAgent
public class MainAgent extends Agent{
    private AID[] someAgents;

    private String idx;
    @Override
    protected void setup() {
        System.out.println("Hello from " + getAID().getName());

        DFAgentDescription dfd = new DFAgentDescription();
        dfd.setName(getAID());
        ServiceDescription sd = new ServiceDescription();
        sd.setType(MainAgent.class.getName());
        sd.setName(MainAgent.class.getName());
        dfd.addServices(sd);
        try {
            DFService.register(this, dfd);
        } catch (FIPAException fe) {
            fe.printStackTrace();
        }

        addBehaviour(new ReceiveMessageBehaviour());

        addBehaviour(new TickerBehaviour(this, 10000) {
            @Override
            protected void onTick() {
                // Update the list of seller agents
                DFAgentDescription template = new DFAgentDescription();
                ServiceDescription sd = new ServiceDescription();
                sd.setType(VisitorsAgent.class.getName());
                template.addServices(sd);
                try {
                    DFAgentDescription[] result = DFService.search(myAgent, template);
                    someAgents = new AID[result.length];
                    for (int i = 0; i < result.length; ++i) {
                        someAgents[i] = result[i].getName();
                    }
                } catch (FIPAException fe) {
                    fe.printStackTrace();
                }
                myAgent.addBehaviour(new SendMessageBehaviour<Visitor>(someAgents, new Visitor()));
            }
        });
        addBehaviour(new CreateOrder());
    }

    public class CreateOrder extends CyclicBehaviour {
        @SneakyThrows
        public void action() {
            addBehaviour(new Behaviour() {
                @Override
                public void action() {
                    ACLMessage msg = myAgent.receive();
                    idx = msg.getContent();
                }

                @Override
                public boolean done() {
                    return false;
                }
            });
            if (idx != null) {
                try {

                    String[] spl = idx.split(" ");
                    for (String mes : spl) {

                        addBehaviour(new TickerBehaviour(this.getAgent(), 10000) {
                            @Override
                            protected void onTick() {
                                // Update the list of seller agents
                                DFAgentDescription template = new DFAgentDescription();
                                ServiceDescription sd = new ServiceDescription();
                                sd.setType(OrderAgent.class.getName());
                                template.addServices(sd);
                                try {
                                    DFAgentDescription[] result = DFService.search(myAgent, template);
                                    someAgents = new AID[result.length];
                                    for (int i = 0; i < result.length; ++i) {
                                        someAgents[i] = result[i].getName();
                                    }
                                } catch (FIPAException fe) {
                                    fe.printStackTrace();
                                }
                                myAgent.addBehaviour(new SendMessageBehaviour<Visitor>(someAgents,
                                        new Visitor()));
//                                не додумал, mes отсылать должен по-хорошему, но так и не получилось сделать это
                            }
                        });

                        addBehaviour(new Behaviour() {
                            @Override
                            public void action() {
                                ACLMessage message = myAgent.receive();
                                if(message != null)
                                {
                                    System.out.println(message.getContent());
                                }
                            }
                            @Override
                            public boolean done() {
                                return false;
                            }
                        });

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                block();
                Remove.removeAgents(myAgent, "agents.MenuAgent");
                Remove.removeAgents(myAgent, FacilitiesAgent.class.getName());
                Remove.removeAgents(myAgent, CookerAgent.class.getName());
                Remove.removeAgents(myAgent, "agents.ProcessAgent");
                doDelete();
            }
        }
    }

    @Override
    protected void takeDown() {
        try {
            DFService.deregister(this);
        } catch (FIPAException fe) {
            fe.printStackTrace();
        }
        System.out.println("mainAgent " + getAID().getName() + " terminating");
    }
}

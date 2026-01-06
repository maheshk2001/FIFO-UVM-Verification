class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;
    fifo_empty_read_sequence reset_seq;
	fifo_RAW_sequence RAW_seq;
  	fifo_overflow_sequence overflow_sequence;
  	fifo_random_sequence random_seq;
  	fifo_ZeroOneR_sequence zeroone_seq;

    function new(string path = "fifo_test",uvm_component parent);
        super.new(path,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);
        reset_seq = fifo_empty_read_sequence::type_id::create("reset_seq");
        reset_seq.start(env.agent_env.seq_agent);
        RAW_seq = fifo_RAW_sequence :: type_id::create("RAW_seq");
        RAW_seq.start(env.agent_env.seq_agent);
        overflow_sequence=fifo_overflow_sequence::type_id::create("overflow_sequence");
        overflow_sequence.start(env.agent_env.seq_agent);
        random_seq = fifo_random_sequence::type_id::create("random_seq");
        random_seq.start(env.agent_env.seq_agent);
  	    zeroone_seq = fifo_ZeroOneR_sequence::type_id::create("zeroone_seq");
        zeroone_seq.start(env.agent_env.seq_agent);
        phase.drop_objection(this);
    endtask

    
endclass
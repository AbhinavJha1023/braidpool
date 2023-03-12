----------------------------- MODULE P2PBroadcast -----------------------------
(***************************************************************************)
(* The specification caputers the DAG base reliable broadcast to           *)
(* disseminate shares over a peer to peer network.                         *)
(*                                                                         *)
(* The broadcast enables nodes to know which nodes have revceived the      *)
(* message by using implicit acknowledgements.  The broadcast is not a BFT *)
(* broadcast.  We depend on the higher layers to provide that.             *)
(*                                                                         *)
(* Does this open this broadcast to a DDoS attack? Yes, and our argument   *)
(* remains that p2p network can resist DDoS attacks by other means.        *)
(*                                                                         *)
(* First pass - We assume no processes failures or messages lost.          *)
(***************************************************************************)

EXTENDS Naturals, Sequences

CONSTANT
            Proc,   \* Set of processes
            Data,
            Nbrs
             
VARIABLES
            sent_by,   \* Set of messages sent by processes to their neighbours
            recv_by    \* Set of messages received by processes

vars == << sent_by, recv_by >>
------------------------------------------------------------------------------
Message == [from: Proc, data: Data]

Init == 
        /\ sent_by = [m \in Message |-> {}]
        /\ recv_by = [m \in Message |-> {}]

TypeInvariant ==
        /\ sent_by \in [Message -> SUBSET Proc]
        /\ recv_by \in [Message -> SUBSET Proc]
------------------------------------------------------------------------------

(***************************************************************************)
(* SendTo(m, p) - send message m to neighbour p                            *)
(*                                                                         *)
(* Sending to self is required as then the message is in the recv list as  *)
(* well.                                                                   *)
(***************************************************************************)
SendTo(m, p) ==
            /\ m.from \notin sent_by[m] \* Don't send again - we can add decay here
            /\ <<m.from, p>> \in Nbrs   \* Send only to neighbours
            /\ sent_by' = [sent_by EXCEPT ![m] = @ \union {p}]
            /\ UNCHANGED <<recv_by>>

(***************************************************************************)
(* RecvAt(m, q) - receive message m at q.  This can be received from       *)
(* forwards                                                                *)
(***************************************************************************)

RecvAt(m, q) ==
            /\ \exists p \in Proc: p \in sent_by[m] \* Some process has sent the message
            /\ q \notin recv_by[m]                  \* Not already received by q
            /\ recv_by' = [recv_by EXCEPT ![m] = @ \union {q}]
            /\ UNCHANGED <<sent_by>>
        
(***************************************************************************)
(* Forward(m, p, q) - forward message m from p to q                        *)
(* Enabling condition - m has been sent by some process, q has received    *) 
(* the message, q is not the sender                                        *)
(* Effect - p forwards the message m to its nbrs                           *)
(***************************************************************************)

Forward(m, p, q) ==
            /\ \exists r \in Proc: r \in sent_by[m] \* Some process has sent the message
            /\ p # q                                \* Don't forward to self
            /\ <<p, q>> \in Nbrs                    \* Forward only to neighbour
            /\ p \in recv_by[m]                     \* p has received m
            /\ sent_by' = [sent_by EXCEPT ![m] = @ \union {q}]
            /\ UNCHANGED <<recv_by>>

Next == \exists p \in Proc, q \in Proc, m \in Message:
            \/ SendTo(m, p)
            \/ RecvAt(m, p)
            \/ Forward(m, p, q)
-----------------------------------------------------------------------------
Spec == /\ Init
        /\ [][Next]_vars

(***************************************************************************)
(* Liveness specifies that if a message is enabled to be received at p, it *)
(* is eventually received at p.                                            *)
(***************************************************************************)
Liveness == \A p \in Proc: \A m \in Message: WF_vars(RecvAt(m, p))

FairSpec == Spec /\ Liveness
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Sun Mar 12 07:24:26 CET 2023 by kulpreet
\* Created Sun Mar 05 15:04:04 CET 2023 by kulpreet

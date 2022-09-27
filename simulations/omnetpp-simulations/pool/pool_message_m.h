//
// Generated file, do not edit! Created by opp_msgtool 6.0 from pool_message.msg.
//

#ifndef __POOL_MESSAGE_M_H
#define __POOL_MESSAGE_M_H

#if defined(__clang__)
#  pragma clang diagnostic ignored "-Wreserved-id-macro"
#endif
#include <omnetpp.h>

// opp_msgtool version check
#define MSGC_VERSION 0x0600
#if (MSGC_VERSION!=OMNETPP_VERSION)
#    error Version mismatch! Probably this file was generated by an earlier version of opp_msgtool: 'make clean' should help.
#endif

class PoolMessage;
/**
 * Class generated from <tt>pool_message.msg:20</tt> by opp_msgtool.
 * <pre>
 * //
 * // Message representing a share broadcast by a miner
 * //
 * message PoolMessage
 * {
 *     int source;
 *     int destination;
 *     int hopCount = 0;
 * }
 * </pre>
 */
class PoolMessage : public ::omnetpp::cMessage
{
  protected:
    int source = 0;
    int destination = 0;
    int hopCount = 0;

  private:
    void copy(const PoolMessage& other);

  protected:
    bool operator==(const PoolMessage&) = delete;

  public:
    PoolMessage(const char *name=nullptr, short kind=0);
    PoolMessage(const PoolMessage& other);
    virtual ~PoolMessage();
    PoolMessage& operator=(const PoolMessage& other);
    virtual PoolMessage *dup() const override {return new PoolMessage(*this);}
    virtual void parsimPack(omnetpp::cCommBuffer *b) const override;
    virtual void parsimUnpack(omnetpp::cCommBuffer *b) override;

    virtual int getSource() const;
    virtual void setSource(int source);

    virtual int getDestination() const;
    virtual void setDestination(int destination);

    virtual int getHopCount() const;
    virtual void setHopCount(int hopCount);
};

inline void doParsimPacking(omnetpp::cCommBuffer *b, const PoolMessage& obj) {obj.parsimPack(b);}
inline void doParsimUnpacking(omnetpp::cCommBuffer *b, PoolMessage& obj) {obj.parsimUnpack(b);}


namespace omnetpp {

template<> inline PoolMessage *fromAnyPtr(any_ptr ptr) { return check_and_cast<PoolMessage*>(ptr.get<cObject>()); }

}  // namespace omnetpp

#endif // ifndef __POOL_MESSAGE_M_H


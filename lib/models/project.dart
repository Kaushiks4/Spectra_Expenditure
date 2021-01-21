class Project {
  String pid,
      pName,
      clientName,
      timeStamp,
      details,
      fee,
      balance,
      date,
      amount,
      name,
      head,
      subhead,
      remarks,
      reciept;
  Project(
      {this.clientName,
      this.details,
      this.fee,
      this.pName,
      this.pid,
      this.timeStamp,
      this.balance});
  Project.view({this.pid, this.pName, this.fee, this.balance});
  Project.select({this.pid, this.pName});
  Project.expense(
      {this.date,
      this.head,
      this.subhead,
      this.amount,
      this.name,
      this.remarks,
      this.reciept});
  Project.income(
      {this.date,
      this.name,
      this.amount,
      this.balance,
      this.remarks,
      this.reciept});
  Project.adminPayment({this.pid, this.fee, this.amount});
  Project.userPayment({this.date, this.name, this.amount});
}

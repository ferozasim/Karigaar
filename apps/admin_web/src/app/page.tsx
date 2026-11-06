'use client';

import React, { useState } from 'react';
import {
  Shield,
  Activity,
  Truck,
  Users,
  AlertTriangle,
  TrendingUp,
  CheckCircle2,
  Clock,
  Radio,
  Send,
  Search,
  SlidersHorizontal,
  FileCheck,
  Check,
  X,
  MapPin,
  Flame,
} from 'lucide-react';

export default function SuperAdminPortal() {
  const [broadcastSent, setBroadcastSent] = useState(false);
  const [verifiedList, setVerifiedList] = useState<string[]>([]);

  const handleApprove = (id: string) => {
    setVerifiedList((prev) => [...prev, id]);
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col">
      {/* Top Header */}
      <header className="bg-slate-900 text-white sticky top-0 z-50 border-b border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-xl bg-amber-500 flex items-center justify-center font-bold text-slate-900 shadow-md">
              <Shield className="w-5 h-5 text-slate-950" />
            </div>
            <div>
              <div className="flex items-center space-x-2">
                <span className="font-extrabold text-base tracking-tight">Karigaar HQ</span>
                <span className="text-xs bg-amber-500/20 text-amber-300 font-semibold px-2 py-0.5 rounded-full border border-amber-500/30">
                  Pilot Ops: Nanded
                </span>
              </div>
              <div className="flex items-center space-x-1.5 text-xs text-slate-400">
                <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                <span>Live Telemetry 99.8%</span>
              </div>
            </div>
          </div>

          <div className="flex items-center space-x-4">
            <button
              onClick={() => {
                setBroadcastSent(true);
                setTimeout(() => setBroadcastSent(false), 3000);
              }}
              className="hidden sm:flex items-center space-x-2 bg-amber-600 hover:bg-amber-500 text-white text-xs font-semibold px-3 py-2 rounded-lg transition-colors shadow-sm"
            >
              <Send className="w-3.5 h-3.5" />
              <span>{broadcastSent ? 'Emergency Alert Broadcasted!' : 'Emergency Surge WA Alert'}</span>
            </button>
            <div className="w-8 h-8 rounded-full bg-slate-700 border border-slate-600 flex items-center justify-center text-xs font-bold text-amber-400">
              HQ
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 flex-1 w-full space-y-6">
        {/* Live Ops Stream Strip */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between bg-white p-4 rounded-xl border border-slate-200 shadow-sm gap-4">
          <div className="flex items-center space-x-3">
            <div className="flex items-center space-x-1.5">
              <span className="relative flex h-2.5 w-2.5">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-amber-500"></span>
              </span>
              <span className="text-xs font-bold uppercase tracking-wider text-slate-700">HQ Ops Stream</span>
            </div>
            <span className="text-xs text-slate-400">• Synced 4s ago</span>
          </div>

          <div className="flex items-center space-x-3 overflow-x-auto pb-1 sm:pb-0">
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <Truck className="w-3.5 h-3.5 text-amber-600" />
              <span>Active Dispatches:</span>
              <span className="font-bold text-slate-900">42</span>
            </div>
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <Users className="w-3.5 h-3.5 text-emerald-600" />
              <span>Online Artisans:</span>
              <span className="font-bold text-emerald-700">89</span>
            </div>
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <AlertTriangle className="w-3.5 h-3.5 text-rose-600" />
              <span>Dispute Rate:</span>
              <span className="font-bold text-rose-600">0.2%</span>
            </div>
          </div>
        </div>

        {/* 2x2 Bento KPI Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Daily GMV */}
          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
            <div className="flex items-center justify-between text-slate-500">
              <span className="text-xs font-semibold uppercase tracking-wider">Daily GMV (Nanded)</span>
              <div className="w-7 h-7 rounded-lg bg-amber-50 flex items-center justify-center text-amber-600">
                ₹
              </div>
            </div>
            <div className="mt-4">
              <div className="text-2xl font-extrabold text-slate-900">₹1,84,500</div>
              <div className="flex items-center space-x-1.5 text-xs text-emerald-600 mt-1 font-semibold">
                <TrendingUp className="w-3.5 h-3.5" />
                <span>+14% vs yesterday</span>
              </div>
            </div>
          </div>

          {/* Completed Bookings */}
          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
            <div className="flex items-center justify-between text-slate-500">
              <span className="text-xs font-semibold uppercase tracking-wider">Completed Jobs</span>
              <div className="w-7 h-7 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600">
                <CheckCircle2 className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-4">
              <div className="text-2xl font-extrabold text-slate-900">328 jobs</div>
              <div className="text-xs text-slate-500 mt-1">Avg turnaround: 28 mins</div>
            </div>
          </div>

          {/* Priority Guild KYC Queue */}
          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
            <div className="flex items-center justify-between text-slate-500">
              <span className="text-xs font-semibold uppercase tracking-wider">KYC Verification Queue</span>
              <div className="w-7 h-7 rounded-lg bg-amber-100 flex items-center justify-center text-amber-700">
                <FileCheck className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-4">
              <div className="text-2xl font-extrabold text-slate-900">18 pending</div>
              <div className="text-xs text-amber-600 mt-1 font-semibold">5 Priority SLA (&lt; 2h)</div>
            </div>
          </div>

          {/* WhatsApp Outbound */}
          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
            <div className="flex items-center justify-between text-slate-500">
              <span className="text-xs font-semibold uppercase tracking-wider">WA Cloud API Relay</span>
              <div className="w-7 h-7 rounded-lg bg-emerald-50 flex items-center justify-center text-emerald-600">
                <Radio className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-4">
              <div className="text-2xl font-extrabold text-slate-900">99.4% Delivery</div>
              <div className="text-xs text-emerald-600 mt-1 font-semibold">1,420 dispatch pings sent</div>
            </div>
          </div>
        </div>

        {/* Nanded Hyperlocal Surge Grid & Verification Queue */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Nanded Surge Grid Heatmap */}
          <div className="lg:col-span-1 bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Flame className="w-5 h-5 text-amber-600" />
                <h3 className="text-sm font-bold text-slate-900">Nanded Surge Corridors</h3>
              </div>
              <span className="text-xs bg-amber-100 text-amber-800 font-bold px-2 py-0.5 rounded">
                Dynamic 1.2x - 1.4x
              </span>
            </div>

            <div className="space-y-3">
              {[
                { name: 'Anand Nagar Hub', surge: '1.4x', status: 'Heavy Demand (Monsoon MCB Tripping)', color: 'border-amber-500 bg-amber-50/50' },
                { name: 'Vazirabad & Sarafa', surge: '1.2x', status: 'Moderate Drain Leakage Calls', color: 'border-slate-200 bg-slate-50' },
                { name: 'CIDCO New Nanded', surge: '1.0x', status: 'Normal Supply-Demand Balance', color: 'border-slate-200 bg-slate-50' },
                { name: 'Taroda Naka Corridor', surge: '1.1x', status: 'AC Deep Service Peak', color: 'border-slate-200 bg-slate-50' },
              ].map((zone, idx) => (
                <div key={idx} className={`p-3 rounded-lg border ${zone.color} flex items-center justify-between`}>
                  <div>
                    <div className="text-xs font-bold text-slate-800 flex items-center space-x-1.5">
                      <MapPin className="w-3.5 h-3.5 text-slate-500" />
                      <span>{zone.name}</span>
                    </div>
                    <div className="text-[11px] text-slate-500 mt-0.5">{zone.status}</div>
                  </div>
                  <span className="text-xs font-extrabold text-amber-700 bg-white px-2 py-1 rounded border border-amber-200 shadow-xs">
                    {zone.surge}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Priority Guild Verification Queue */}
          <div className="lg:col-span-2 bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="text-sm font-bold text-slate-900">Priority Guild Verification Queue</h3>
                <p className="text-xs text-slate-500">Aadhaar KYC, Police Background & NSDC Laser Tool Audits</p>
              </div>
              <span className="text-xs font-semibold text-slate-500">5 High Priority</span>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-slate-200 text-xs">
                <thead>
                  <tr className="text-left text-slate-500 font-semibold">
                    <th className="pb-3">Artisan</th>
                    <th className="pb-3">Trade</th>
                    <th className="pb-3">Locality</th>
                    <th className="pb-3">Documents</th>
                    <th className="pb-3 text-right">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {[
                    { id: 'art_01', name: 'Ganesh Kadam', trade: 'Master Electrician', loc: 'Anand Nagar', docs: 'Aadhaar + Police Cleared' },
                    { id: 'art_02', name: 'Sayyed Arshad', trade: 'Plumber', loc: 'Vazirabad', docs: 'Aadhaar + NSDC Cert' },
                    { id: 'art_03', name: 'Prakash Sutar', trade: 'Carpenter', loc: 'CIDCO', docs: 'Aadhaar + Police Pending' },
                    { id: 'art_04', name: 'Sachin Waghmare', trade: 'AC & Refrigeration', loc: 'Taroda Naka', docs: 'Aadhaar + Tool Calibrated' },
                  ].map((art) => {
                    const isApproved = verifiedList.includes(art.id);
                    return (
                      <tr key={art.id} className="hover:bg-slate-50/80">
                        <td className="py-3 font-semibold text-slate-900">{art.name}</td>
                        <td className="py-3 text-slate-600">{art.trade}</td>
                        <td className="py-3 text-slate-600">{art.loc}</td>
                        <td className="py-3">
                          <span className="bg-emerald-50 text-emerald-700 px-2 py-0.5 rounded font-medium border border-emerald-200">
                            {art.docs}
                          </span>
                        </td>
                        <td className="py-3 text-right">
                          {isApproved ? (
                            <span className="inline-flex items-center text-emerald-600 font-bold">
                              <Check className="w-3.5 h-3.5 mr-1" /> Approved
                            </span>
                          ) : (
                            <div className="inline-flex space-x-1.5">
                              <button
                                onClick={() => handleApprove(art.id)}
                                className="bg-emerald-600 hover:bg-emerald-500 text-white px-2.5 py-1 rounded font-semibold text-xs"
                              >
                                Approve
                              </button>
                              <button className="bg-slate-200 hover:bg-slate-300 text-slate-700 px-2.5 py-1 rounded font-semibold text-xs">
                                Review
                              </button>
                            </div>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

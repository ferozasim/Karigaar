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
  Globe,
  Filter,
} from 'lucide-react';

interface DistrictOption {
  id: string;
  name: string;
  short: string;
  activeHubs: number;
  state: string;
}

const DISTRICTS: DistrictOption[] = [
  { id: 'all', name: 'Regional Corridor (7 Districts)', short: 'All Corridor', activeHubs: 35, state: 'MH & TS' },
  { id: 'city_nanded_01', name: 'Nanded-Waghala', short: 'Nanded', activeHubs: 10, state: 'Maharashtra' },
  { id: 'dist_parbhani', name: 'Parbhani City', short: 'Parbhani', activeHubs: 3, state: 'Maharashtra' },
  { id: 'dist_latur', name: 'Latur City', short: 'Latur', activeHubs: 4, state: 'Maharashtra' },
  { id: 'dist_hingoli', name: 'Hingoli City', short: 'Hingoli', activeHubs: 2, state: 'Maharashtra' },
  { id: 'dist_aurangabad', name: 'Chhatrapati Sambhajinagar', short: 'Sambhajinagar', activeHubs: 6, state: 'Maharashtra' },
  { id: 'dist_nagpur', name: 'Nagpur City', short: 'Nagpur', activeHubs: 5, state: 'Maharashtra' },
  { id: 'dist_nizamabad', name: 'Nizamabad City', short: 'Nizamabad', activeHubs: 5, state: 'Telangana' },
];

interface DistrictMetrics {
  gmv: string;
  gmvGrowth: string;
  completedJobs: string;
  avgTurnaround: string;
  activeDispatches: number;
  onlineArtisans: number;
  disputeRate: string;
  pendingKyc: number;
  priorityKyc: number;
  waPings: string;
}

const METRICS_MAP: Record<string, DistrictMetrics> = {
  all: {
    gmv: '₹6,42,800',
    gmvGrowth: '+18% vs yesterday',
    completedJobs: '1,142 jobs',
    avgTurnaround: '26 mins avg',
    activeDispatches: 148,
    onlineArtisans: 312,
    disputeRate: '0.18%',
    pendingKyc: 42,
    priorityKyc: 11,
    waPings: '4,890 pings',
  },
  city_nanded_01: {
    gmv: '₹1,84,500',
    gmvGrowth: '+14% vs yesterday',
    completedJobs: '328 jobs',
    avgTurnaround: '28 mins avg',
    activeDispatches: 42,
    onlineArtisans: 89,
    disputeRate: '0.20%',
    pendingKyc: 18,
    priorityKyc: 5,
    waPings: '1,420 pings',
  },
  dist_parbhani: {
    gmv: '₹68,400',
    gmvGrowth: '+9% vs yesterday',
    completedJobs: '124 jobs',
    avgTurnaround: '24 mins avg',
    activeDispatches: 16,
    onlineArtisans: 34,
    disputeRate: '0.10%',
    pendingKyc: 4,
    priorityKyc: 1,
    waPings: '540 pings',
  },
  dist_latur: {
    gmv: '₹92,100',
    gmvGrowth: '+12% vs yesterday',
    completedJobs: '168 jobs',
    avgTurnaround: '25 mins avg',
    activeDispatches: 22,
    onlineArtisans: 48,
    disputeRate: '0.25%',
    pendingKyc: 5,
    priorityKyc: 2,
    waPings: '710 pings',
  },
  dist_hingoli: {
    gmv: '₹38,200',
    gmvGrowth: '+6% vs yesterday',
    completedJobs: '68 jobs',
    avgTurnaround: '22 mins avg',
    activeDispatches: 9,
    onlineArtisans: 21,
    disputeRate: '0.00%',
    pendingKyc: 3,
    priorityKyc: 1,
    waPings: '310 pings',
  },
  dist_aurangabad: {
    gmv: '₹1,42,000',
    gmvGrowth: '+16% vs yesterday',
    completedJobs: '246 jobs',
    avgTurnaround: '27 mins avg',
    activeDispatches: 31,
    onlineArtisans: 64,
    disputeRate: '0.19%',
    pendingKyc: 6,
    priorityKyc: 2,
    waPings: '1,080 pings',
  },
  dist_nagpur: {
    gmv: '₹1,82,600',
    gmvGrowth: '+21% vs yesterday',
    completedJobs: '314 jobs',
    avgTurnaround: '29 mins avg',
    activeDispatches: 38,
    onlineArtisans: 72,
    disputeRate: '0.22%',
    pendingKyc: 7,
    priorityKyc: 2,
    waPings: '1,320 pings',
  },
  dist_nizamabad: {
    gmv: '₹75,000',
    gmvGrowth: '+11% vs yesterday',
    completedJobs: '134 jobs',
    avgTurnaround: '25 mins avg',
    activeDispatches: 17,
    onlineArtisans: 38,
    disputeRate: '0.14%',
    pendingKyc: 4,
    priorityKyc: 1,
    waPings: '580 pings',
  },
};

interface SurgeZone {
  districtId: string;
  name: string;
  surge: string;
  status: string;
  color: string;
}

const SURGE_ZONES: SurgeZone[] = [
  // Nanded
  { districtId: 'city_nanded_01', name: 'Anand Nagar Hub (Nanded)', surge: '1.4x', status: 'Heavy Monsoon MCB Tripping Demand', color: 'border-amber-500 bg-amber-50/50' },
  { districtId: 'city_nanded_01', name: 'Vazirabad & Sarafa (Nanded)', surge: '1.2x', status: 'Moderate Drain Leakage Calls', color: 'border-slate-200 bg-slate-50' },
  { districtId: 'city_nanded_01', name: 'CIDCO New Nanded', surge: '1.0x', status: 'Balanced Supply-Demand', color: 'border-slate-200 bg-slate-50' },
  { districtId: 'city_nanded_01', name: 'Taroda Naka Corridor (Nanded)', surge: '1.1x', status: 'AC Deep Service Peak', color: 'border-slate-200 bg-slate-50' },

  // Parbhani
  { districtId: 'dist_parbhani', name: 'Station Road Hub (Parbhani)', surge: '1.3x', status: 'Appliance Repair Rush', color: 'border-amber-500 bg-amber-50/50' },
  { districtId: 'dist_parbhani', name: 'Shivaji Nagar (Parbhani)', surge: '1.1x', status: 'Electrician Callouts', color: 'border-slate-200 bg-slate-50' },

  // Latur
  { districtId: 'dist_latur', name: 'Gandhi Chowk Market (Latur)', surge: '1.3x', status: 'Plumbing & Commercial Line Repair', color: 'border-amber-500 bg-amber-50/50' },
  { districtId: 'dist_latur', name: 'MIDC Industrial Corridor (Latur)', surge: '1.2x', status: 'Welder & Heavy Fabrication Peak', color: 'border-slate-200 bg-slate-50' },

  // Hingoli
  { districtId: 'dist_hingoli', name: 'Ramakrishna Nagar (Hingoli)', surge: '1.2x', status: 'Masonry & Waterproofing Work', color: 'border-amber-500 bg-amber-50/50' },

  // Sambhajinagar
  { districtId: 'dist_aurangabad', name: 'Cidco N-1 to N-4 (Sambhajinagar)', surge: '1.4x', status: 'Electrical Distribution Overhaul', color: 'border-amber-500 bg-amber-50/50' },
  { districtId: 'dist_aurangabad', name: 'Cannaught Place Market (Sambhajinagar)', surge: '1.2x', status: 'Appliance Repair Spike', color: 'border-slate-200 bg-slate-50' },

  // Nagpur
  { districtId: 'dist_nagpur', name: 'Dharampeth & West Nagpur', surge: '1.4x', status: 'HVAC Aircon Servicing Peak', color: 'border-amber-500 bg-amber-50/50' },
  { districtId: 'dist_nagpur', name: 'Sitabuldi Central Hub (Nagpur)', surge: '1.2x', status: 'Plumber & Water Motor Replacement', color: 'border-slate-200 bg-slate-50' },

  // Nizamabad
  { districtId: 'dist_nizamabad', name: 'Khaleelwadi Commercial Hub (Nizamabad)', surge: '1.3x', status: 'Deep Cleaning & Electrical Fitout', color: 'border-amber-500 bg-amber-50/50' },
  { districtId: 'dist_nizamabad', name: 'Bodhan Road Corridor (Nizamabad)', surge: '1.1x', status: 'Carpenter Woodwork Demands', color: 'border-slate-200 bg-slate-50' },
];

interface KycArtisan {
  id: string;
  districtId: string;
  districtName: string;
  name: string;
  trade: string;
  loc: string;
  docs: string;
  priority: boolean;
}

const KYC_CANDIDATES: KycArtisan[] = [
  { id: 'art_01', districtId: 'city_nanded_01', districtName: 'Nanded', name: 'Ganesh Kadam', trade: 'Master Electrician', loc: 'Anand Nagar', docs: 'Aadhaar + Police Cleared', priority: true },
  { id: 'art_02', districtId: 'city_nanded_01', districtName: 'Nanded', name: 'Sayyed Arshad', trade: 'Plumber', loc: 'Vazirabad', docs: 'Aadhaar + NSDC Cert', priority: false },
  { id: 'art_03', districtId: 'dist_parbhani', districtName: 'Parbhani', name: 'Balaji Rathod', trade: 'Mason / Gawandi', loc: 'Station Road', docs: 'Aadhaar + Laser Level Audit', priority: true },
  { id: 'art_04', districtId: 'dist_latur', districtName: 'Latur', name: 'Prakash Sutar', trade: 'Master Carpenter', loc: 'Gandhi Chowk', docs: 'Aadhaar + Police Cleared', priority: true },
  { id: 'art_05', districtId: 'dist_hingoli', districtName: 'Hingoli', name: 'Rameshwar Pawar', trade: 'Welder & Fabricator', loc: 'Ramakrishna Nagar', docs: 'Aadhaar + Safety Kit Audit', priority: false },
  { id: 'art_06', districtId: 'dist_aurangabad', districtName: 'Sambhajinagar', name: 'Deepak Shinde', trade: 'Master Electrician', loc: 'Cidco N-2', docs: 'Aadhaar + DigiLocker OCR Verified', priority: true },
  { id: 'art_07', districtId: 'dist_nagpur', districtName: 'Nagpur', name: 'Sunil Meshram', trade: 'AC & Refrigeration', loc: 'Dharampeth', docs: 'Aadhaar + Fluke Tool Calibrated', priority: true },
  { id: 'art_08', districtId: 'dist_nizamabad', districtName: 'Nizamabad', name: 'K. Venkateshwarlu', trade: 'Plumber & Pipe Fitter', loc: 'Khaleelwadi', docs: 'Aadhaar + Police Cleared', priority: false },
];

export default function SuperAdminPortal() {
  const [selectedDistrict, setSelectedDistrict] = useState<string>('all');
  const [broadcastSent, setBroadcastSent] = useState(false);
  const [verifiedList, setVerifiedList] = useState<string[]>([]);

  const handleApprove = (id: string) => {
    setVerifiedList((prev) => [...prev, id]);
  };

  const activeDistrictObj = DISTRICTS.find((d) => d.id === selectedDistrict) || DISTRICTS[0];
  const metrics = METRICS_MAP[selectedDistrict] || METRICS_MAP['all'];

  const filteredSurge = selectedDistrict === 'all'
    ? SURGE_ZONES.slice(0, 5)
    : SURGE_ZONES.filter((z) => z.districtId === selectedDistrict);

  const filteredKyc = selectedDistrict === 'all'
    ? KYC_CANDIDATES
    : KYC_CANDIDATES.filter((k) => k.districtId === selectedDistrict);

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
                  Regional Ops: {activeDistrictObj.short}
                </span>
              </div>
              <div className="flex items-center space-x-1.5 text-xs text-slate-400">
                <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                <span>Live Telemetry 99.8% • 7 Corridor Districts Active</span>
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
              <span>
                {broadcastSent
                  ? `Alert Broadcasted to ${activeDistrictObj.short}!`
                  : `Surge WA Alert (${activeDistrictObj.short})`}
              </span>
            </button>
            <div className="w-8 h-8 rounded-full bg-slate-700 border border-slate-600 flex items-center justify-center text-xs font-bold text-amber-400">
              HQ
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 flex-1 w-full space-y-6">
        {/* Regional District Corridor Filter Bar */}
        <div className="bg-white p-3 rounded-xl border border-slate-200 shadow-sm flex items-center justify-between flex-wrap gap-2">
          <div className="flex items-center space-x-2 text-xs font-bold text-slate-700 uppercase tracking-wider">
            <Globe className="w-4 h-4 text-amber-600" />
            <span>Regional Corridor Filter:</span>
          </div>
          <div className="flex items-center space-x-1.5 overflow-x-auto py-1 max-w-full">
            {DISTRICTS.map((dist) => {
              const isSelected = selectedDistrict === dist.id;
              return (
                <button
                  key={dist.id}
                  onClick={() => setSelectedDistrict(dist.id)}
                  className={`px-3 py-1.5 rounded-lg text-xs font-semibold whitespace-nowrap transition-all ${
                    isSelected
                      ? 'bg-slate-900 text-white shadow-sm'
                      : 'bg-slate-100 hover:bg-slate-200 text-slate-600'
                  }`}
                >
                  {dist.short}
                  <span className={`ml-1.5 text-[10px] px-1.5 py-0.2 rounded-full ${isSelected ? 'bg-amber-500 text-slate-950 font-bold' : 'bg-slate-200 text-slate-500'}`}>
                    {dist.activeHubs} hubs
                  </span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Live Ops Stream Strip */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between bg-white p-4 rounded-xl border border-slate-200 shadow-sm gap-4">
          <div className="flex items-center space-x-3">
            <div className="flex items-center space-x-1.5">
              <span className="relative flex h-2.5 w-2.5">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-amber-500"></span>
              </span>
              <span className="text-xs font-bold uppercase tracking-wider text-slate-700">
                HQ Ops Stream ({activeDistrictObj.name})
              </span>
            </div>
            <span className="text-xs text-slate-400">• Real-time GPS stream</span>
          </div>

          <div className="flex items-center space-x-3 overflow-x-auto pb-1 sm:pb-0">
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <Truck className="w-3.5 h-3.5 text-amber-600" />
              <span>Active Dispatches:</span>
              <span className="font-bold text-slate-900">{metrics.activeDispatches}</span>
            </div>
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <Radio className="w-3.5 h-3.5 text-indigo-600" />
              <span>Radar 45s Broadcasts:</span>
              <span className="font-bold text-indigo-700">98.2% &lt;45s claim</span>
            </div>
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <Users className="w-3.5 h-3.5 text-emerald-600" />
              <span>Online Artisans:</span>
              <span className="font-bold text-emerald-700">{metrics.onlineArtisans}</span>
            </div>
            <div className="flex items-center space-x-2 bg-slate-100 px-3 py-1.5 rounded-full text-xs font-medium">
              <AlertTriangle className="w-3.5 h-3.5 text-rose-600" />
              <span>Dispute Rate:</span>
              <span className="font-bold text-rose-600">{metrics.disputeRate}</span>
            </div>
          </div>
        </div>

        {/* 2x2 Bento KPI Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Daily GMV */}
          <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
            <div className="flex items-center justify-between text-slate-500">
              <span className="text-xs font-semibold uppercase tracking-wider">Daily GMV ({activeDistrictObj.short})</span>
              <div className="w-7 h-7 rounded-lg bg-amber-50 flex items-center justify-center text-amber-600 font-bold">
                ₹
              </div>
            </div>
            <div className="mt-4">
              <div className="text-2xl font-extrabold text-slate-900">{metrics.gmv}</div>
              <div className="flex items-center space-x-1.5 text-xs text-emerald-600 mt-1 font-semibold">
                <TrendingUp className="w-3.5 h-3.5" />
                <span>{metrics.gmvGrowth}</span>
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
              <div className="text-2xl font-extrabold text-slate-900">{metrics.completedJobs}</div>
              <div className="text-xs text-slate-500 mt-1">{metrics.avgTurnaround}</div>
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
              <div className="text-2xl font-extrabold text-slate-900">{metrics.pendingKyc} pending</div>
              <div className="text-xs text-amber-600 mt-1 font-semibold">
                {metrics.priorityKyc} Priority SLA (&lt; 2h)
              </div>
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
              <div className="text-xs text-emerald-600 mt-1 font-semibold">{metrics.waPings} sent</div>
            </div>
          </div>
        </div>

        {/* Regional Hyperlocal Surge Grid & Verification Queue */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Surge Grid Heatmap */}
          <div className="lg:col-span-1 bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Flame className="w-5 h-5 text-amber-600" />
                <h3 className="text-sm font-bold text-slate-900">
                  {selectedDistrict === 'city_nanded_01'
                    ? 'Nanded Surge Corridors'
                    : `Surge Corridors (${activeDistrictObj.short})`}
                </h3>
              </div>
              <span className="text-xs bg-amber-100 text-amber-800 font-bold px-2 py-0.5 rounded">
                Dynamic 1.1x - 1.4x
              </span>
            </div>

            <div className="space-y-3">
              {filteredSurge.map((zone, idx) => (
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
                <p className="text-xs text-slate-500">
                  Aadhaar KYC, Police Background & NSDC Laser Tool Audits ({activeDistrictObj.name})
                </p>
              </div>
              <span className="text-xs font-semibold text-slate-500">
                {filteredKyc.filter((k) => k.priority).length} High Priority
              </span>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-slate-200 text-xs">
                <thead>
                  <tr className="text-left text-slate-500 font-semibold">
                    <th className="pb-3">Artisan</th>
                    <th className="pb-3">District</th>
                    <th className="pb-3">Trade</th>
                    <th className="pb-3">Locality</th>
                    <th className="pb-3">Documents</th>
                    <th className="pb-3 text-right">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {filteredKyc.map((art) => {
                    const isApproved = verifiedList.includes(art.id);
                    return (
                      <tr key={art.id} className="hover:bg-slate-50/80">
                        <td className="py-3 font-semibold text-slate-900">
                          {art.name}
                          {art.priority && (
                            <span className="ml-1.5 text-[10px] bg-amber-100 text-amber-800 font-bold px-1.5 py-0.2 rounded">
                              Priority
                            </span>
                          )}
                        </td>
                        <td className="py-3 text-slate-600 font-medium">{art.districtName}</td>
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
